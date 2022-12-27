#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/times.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/mman.h>
#include <netinet/tcp.h>
#include <pthread.h>

#define DIE(x) perror(x),exit(1)
#define PORT 13000
#define BUFFER_SIZE 10000

clock_t old_time,new_time;//use for count executing time
clock_t last_time, this_time;
struct tms time_start, time_end;//use for count executing time
struct tms time_last, time_this;
double ticks;

char cc_method[15] = {0};
int Background_TCP_Number = 0;
double total_recv_size = 0;
double last_total_recv_size = 0;
int t = 0;
void* timer(void* arg)
{
    int block = 11;
    last_time = times(&time_last);
    char file_name[50] = {0};
    sprintf(file_name, "TCP_%s_Receiver2_%d_DataRate.csv", cc_method, Background_TCP_Number);
    int ex_rate = open(file_name, O_CREAT|O_RDWR, S_IRWXU);               // use to record 10 sec average data rate

    double throughput = 0;
    ticks = sysconf(_SC_CLK_TCK);
    char str[100] = {0};
	printf("timer create\n");
    sprintf(str, "Time\tBK_TCP\tAverage_Throughput(Mb)\n");
    write(ex_rate, str, sizeof(str));
    while(1)
    {
		sleep(1);
        t++;
        if(t % 10 == 0)  // 10 秒紀錄一次並計算平均速率
        {
            memset(str, '\0', sizeof(str));
            this_time = times(&time_this);
            throughput = ((total_recv_size - last_total_recv_size)*8/1000000)/((this_time - last_time)/ticks);

            // 暫存目前數值
            last_time = this_time;
            last_total_recv_size = total_recv_size;

            sprintf(str, "%d\t%d\t%lf\n", block, Background_TCP_Number, throughput);
            write(ex_rate, str, sizeof(str));
            block++;
        }
        if(t == 200)
        {
            if((new_time = times(&time_end)) == -1)
            {
                printf("time error\n");
                exit(1);
            }
            ticks = sysconf(_SC_CLK_TCK);
            double execute_time = (new_time - old_time) / ticks;
            printf("Execute time : %2.2f\n", execute_time);
            printf("Total Recv Size : %lf\n", total_recv_size);
            close(ex_rate);
            pthread_exit(0);
        }
            
    }
}
int main(int argc, char **argv)
{
    int sd;
    static struct sockaddr_in server;
    char buf[256];
    socklen_t len;

    struct stat sb;
   
    pthread_t t1;
    char recv_buf[BUFFER_SIZE] = {0};

    long long int recv_size = 0;

    if(argc != 4)
    {
        printf("Usage: %s <server_ip> <Background TCP Number> <congestion control>\n",argv[0]);
        exit(1);
    }
    
    strcpy(cc_method, argv[3]);
    Background_TCP_Number = atoi(argv[2]);
    /* Set up destination address. */
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = inet_addr(argv[1]);
    server.sin_port = htons(PORT);
    
    printf("Client Socket Open:\n");
    sd = socket(AF_INET,SOCK_STREAM,0);
    
    // get current congestion control
    len = sizeof(buf);
    if (getsockopt(sd, IPPROTO_TCP, TCP_CONGESTION, buf, &len) != 0)
    {
        perror("getsockopt");
        return -1;
    }

    printf("Current: %s\n", buf);
    
    // set current congestion control to bbr
    
    if(strcmp(argv[3], "bbr") == 0)
    {
        strcpy(buf, "bbr");

        len = strlen(buf);

        if (setsockopt(sd, IPPROTO_TCP, TCP_CONGESTION, buf, len) != 0)
        {
            perror("setsockopt");
            return -1;
        }
    }
    len = sizeof(buf);
    if (getsockopt(sd, IPPROTO_TCP, TCP_CONGESTION, buf, &len) != 0)
    {
        perror("getsockopt");
        return -1;
    }

    printf("Change to: %s\n", buf);
    if(sd < 0)
    {
        DIE("socket");
    }

    /* Connect to the server. */
    if(connect(sd,(struct sockaddr*)&server,sizeof(server)) == -1)
    {
        DIE("connect");
    }
    printf("TCP2 connect successfully\n");
    printf("Start Receiving!\n");

    /*receive packet*/

    int fd;
    int j = 0;
    // open file 
    fd = open("file.txt", O_CREAT|O_RDWR|O_TRUNC, S_IRWXU);
    if (fd == -1) {
        perror("open\n");
        exit(EXIT_FAILURE);
    }
    sleep(90);
    while(1)
    {
        if((recv_size = recv(sd, (char *)recv_buf, BUFFER_SIZE, 0)) < 0)
        {
            DIE("send");
        }
        if(j == 0)
        {
            if(pthread_create(&t1, NULL, timer, NULL) != 0)
            {
                printf("pthread create error\n");
                exit(1);
            }
            if((old_time = times(&time_start)) == -1)
            {
                printf("time error\n");
                exit(1);
            }
            j++;
        }
        if(write(fd, recv_buf, recv_size) < 0)
        {
            DIE("write");
        }
        total_recv_size += recv_size;
        if(t == 200)
            break;
    }
    if(pthread_join(t1, NULL) != 0)
    {
        printf("pthread_join error\n");
        exit(1);
    }
    
    close(fd);
    
    //close connection
    close(sd);

}

