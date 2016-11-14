#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <opencv2/opencv.hpp>

#ifdef _WIN32
#include <Windows.h>
#else
#include <mach/clock.h>
#include <mach/mach.h>
#include <pthread.h>
#endif

#define	IMG_SIZE	512
#define	VIEW_SIZE	501
#define	DET_NUM		IMG_SIZE
#define	CD_SIZE		256
#define	PI			3.141592653589792323846264338327950288419
#define THREAD_NUM  2

//#define DEBUG_WINDOW
//#define MULTI_THREAD

namespace kukdh1
{
	struct POINT{
		unsigned int i;
		unsigned int j;
	};
}

cv::Mat img(IMG_SIZE, IMG_SIZE, CV_64FC1);
cv::Mat img_weight(IMG_SIZE, IMG_SIZE, CV_64FC1);
cv::Mat x_grid(IMG_SIZE, IMG_SIZE, CV_64FC1);
cv::Mat y_grid(IMG_SIZE, IMG_SIZE, CV_64FC1);
cv::Mat distance(IMG_SIZE, IMG_SIZE, CV_64FC1);
cv::Mat view_angle(1, VIEW_SIZE, CV_64FC1);
cv::Mat proj(IMG_SIZE, VIEW_SIZE, CV_64FC1);
cv::Mat proj_weight(IMG_SIZE, VIEW_SIZE, CV_64FC1);
cv::Mat p(IMG_SIZE * 2, IMG_SIZE * 2, CV_64FC1);
std::vector<kukdh1::POINT> FOV_index;

void NMR3(cv::Mat &RADON, double angle);
void forward_projection_dot(cv::Mat &mat, cv::Mat &img, cv::Mat &angle);
void interp1(cv::Mat &ori_x, cv::Mat &data, cv::Mat &new_x, cv::Mat &out);

#ifndef _WIN32
#define fopen_s(a, b, c)        *a = fopen(b, c)
#define _fseeki64               fseek
#define _ftelli64               ftell
#define fread_s(a, b, c, d, e)  fread(a, c, d, e)
#define strtok_s(a, b, c)       strtok(a, b)
#define sprintf_s               sprintf

#define DWORD       unsigned long
#define LONG        long
#define LONGLONG    long long

#define LPVOID      void*
#define THREAD_     LPVOID
#define THREAD_HANDLE   pthread_t

typedef union _LARGE_INTEGER {
	struct {
		DWORD LowPart;
		LONG  HighPart;
	};
	struct {
		DWORD LowPart;
		LONG  HighPart;
	} u;
	LONGLONG QuadPart;
} LARGE_INTEGER, *PLARGE_INTEGER;
#else
#define THREAD_     DWORD WINAPI
#define THREAD_HANDLE   HANDLE
#endif

struct DOT_WRAPPER
{
	cv::Mat *angle;
	cv::Mat *mat;
	int count;
	int length;
};
struct INTERP_WRAPPER
{
	cv::Mat *out;
	cv::Mat *diff;
	cv::Mat *ori_x;
	cv::Mat *data_x;
	cv::Mat *new_x;
	int idx;
	int length;
};

THREAD_ forward_projection_dot_parallel(LPVOID arg);
THREAD_ interp1_parallel(LPVOID arg);

class StopWatch{
#ifdef _WIN32
private:
	LARGE_INTEGER freq;
	LARGE_INTEGER startcount, endcount;
public:
	void start()
	{
		QueryPerformanceCounter(&startcount);
		QueryPerformanceFrequency(&freq);
	}
	void end()
	{
		QueryPerformanceCounter(&endcount);
	}
	LARGE_INTEGER get()
	{
		endcount.QuadPart = endcount.QuadPart - startcount.QuadPart;
		endcount.QuadPart *= 1000000; //us
		endcount.QuadPart /= freq.QuadPart;

		return endcount;
	}
#else
private:
	timespec tstart, tend;
	clock_serv_t cclock;
	mach_timespec_t mts;
public:
	void start()
	{
		host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
		clock_get_time(cclock, &mts);
		mach_port_deallocate(mach_task_self(), cclock);
		tstart.tv_sec = mts.tv_sec;
		tstart.tv_nsec = mts.tv_nsec;
	}
	void end()
	{
		host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
		clock_get_time(cclock, &mts);
		mach_port_deallocate(mach_task_self(), cclock);
		tend.tv_sec = mts.tv_sec;
		tend.tv_nsec = mts.tv_nsec;
	}
	LARGE_INTEGER get()
	{
		LARGE_INTEGER res;

		res.QuadPart = (tend.tv_sec - tstart.tv_sec) * 1000000 + (tend.tv_nsec - tstart.tv_nsec) / 1000;

		return res;
	}
#endif
};

int main(int argc, char *argv[])
{
	//--Initialization--//
	FILE *in;
	long long len;
	char *file;
	StopWatch watch;

	//Open File
	fopen_s(&in, "input512.txt", "rb");

	//Calculate File Size
	_fseeki64(in, 0, SEEK_END);
	len = _ftelli64(in);

	//Allocate Memory
	file = (char *)calloc(len, sizeof(char));

	_fseeki64(in, 0, SEEK_SET);

	//Read Whole File
	fread_s(file, len, sizeof(char), len, in);

#ifdef _WIN32
	char *handle;
#endif
	char *token;

	//Parse File
	token = strtok_s(file, " ,\r\n", &handle);
	for (int i = 0; i < IMG_SIZE; i++)
	{
		for (int j = 0; j < IMG_SIZE; j++)
		{
			img.at<cv::Vec<double, 1>>(i, j) = atof(token);
			img_weight.at<cv::Vec<double, 1>>(i, j) = 1.0;
			token = strtok_s(NULL, " ,\r\n", &handle);
		}
	}

	//Cleanup
	fclose(in);
	free(file);

	//Create x_grid, y_grid and distance
	//step always equals to 1
	kukdh1::POINT pt;

	for (int i = 0; i < IMG_SIZE; i++)
	{
		for (int j = 0; j < IMG_SIZE; j++)
		{
			x_grid.at<cv::Vec<double, 1>>(i, j) = -(IMG_SIZE - 1) / 2.0 + j;
			y_grid.at<cv::Vec<double, 1>>(i, j) = -(IMG_SIZE - 1) / 2.0 + i;
			distance.at<cv::Vec<double, 1>>(i, j) = sqrt(pow(x_grid.at<cv::Vec<double, 1>>(i, j)[0], 2) + pow(y_grid.at<cv::Vec<double, 1>>(i, j)[0], 2));
			if (distance.at<cv::Vec<double, 1>>(i, j)[0] >= IMG_SIZE / 2.0)
			{
				pt.i = i;
				pt.j = j;
				FOV_index.push_back(pt);
			}
		}
	}

	//--Initialization End--//
	printf("Initialize End\n");

	//--Calculate original sinogram--//

	//Make view_angle array
	for (int i = 0; i < VIEW_SIZE; i++)
		view_angle.at<cv::Vec<double, 1>>(0, i) = PI / VIEW_SIZE * i;

	//Calculate sinogram
	watch.start();
	forward_projection_dot(proj, img, view_angle);
	forward_projection_dot(proj_weight, img_weight, view_angle);
	watch.end();

#ifdef _WIN32
	printf("Elapsed Time : %ld us\n", watch.get().QuadPart);
#else
	printf("Elapsed Time : %lld us\n", watch.get().QuadPart);
#endif
	cv::imshow("proj", proj / 130);
	cv::imshow("proj_weight", proj_weight / 512);
	cv::waitKey(1);

	cv::waitKey(0);
	exit(0);

	//Initialization of iterative reconstruction
	cv::Mat dy(1, IMG_SIZE, CV_64FC1);

	for (int i = 0; i < IMG_SIZE; i++)
		dy.at<cv::Vec<double, 1>>(0, i) = IMG_SIZE / 2 - 0.5 - i;

	cv::Mat recon_x_temp(IMG_SIZE, IMG_SIZE, CV_64FC1);
	cv::Mat recon_y_temp(IMG_SIZE, IMG_SIZE, CV_64FC1);
	cv::Mat tmp, tmp2, tmp3, tmp4;

	cv::flip(dy, tmp, 1);
	cv::transpose(dy, tmp2);

	for (int i = 0; i < IMG_SIZE; i++)
	{
		tmp.copyTo(recon_x_temp(cv::Rect(0, i, tmp.cols, tmp.rows)));
		tmp2.copyTo(recon_y_temp(cv::Rect(i, 0, tmp2.cols, tmp2.rows)));
	}

	tmp.release();
	tmp2.release();

	cv::Mat img_iter(IMG_SIZE, IMG_SIZE, CV_64FC1, double(0));	//Result Image
	cv::Mat recon;
	//Iterative Reconstruction
	int viewcount;
	cv::Mat proj_filtered1(IMG_SIZE, 1, CV_64FC1);
	cv::Mat recon_y(IMG_SIZE, IMG_SIZE, CV_64FC1);
	tmp.create(IMG_SIZE, 1, CV_64FC1);

	view_angle.release();
	view_angle.create(1, 1, CV_64FC1);

	char str[20];
	double min, max;

	for (int whole = 0; whole < 6; whole++)
	{
		viewcount = 0;
		watch.start();
		for (double theta = 0; theta < PI; theta += PI / VIEW_SIZE)
		{
			view_angle.at<cv::Vec<double, 1>>(0, 0) = theta;

			forward_projection_dot(tmp, img_iter, view_angle);
			tmp2 = proj(cv::Rect(viewcount, 0, 1, IMG_SIZE));
			tmp3 = proj_weight(cv::Rect(viewcount, 0, 1, IMG_SIZE)) * 2;

			proj_filtered1 = (tmp2 - tmp).mul(1 / tmp3);

			//recon_y is depend on theta, we can make table for less computation time
			recon_y = recon_x_temp * -sin(theta) + recon_y_temp * cos(theta);
			interp1(dy, proj_filtered1, recon_y, recon);

			img_iter = img_iter + recon;

			for (int i = 0; i < IMG_SIZE * IMG_SIZE; i++)
			{
				if (img_iter.at<cv::Vec<double, 1>>(i)[0] < 0)
					img_iter.at<cv::Vec<double, 1>>(i)[0] = 0;
			}

			for (int i = 0; i < FOV_index.size(); i++)
				img_iter.at<cv::Vec<double, 1>>(FOV_index.at(i).i, FOV_index.at(i).j) = 0;

			viewcount++;
		}
		watch.end();
		sprintf_s(str, "img %d", whole + 1);

		cv::minMaxIdx(img_iter, &min, &max);
		cv::imshow(str, img_iter);
		cv::waitKey(1);

#ifdef _WIN32
		printf("%s : %ld us\n", str, watch.get().QuadPart);
#else
		printf("%s : %lld us\n", str, watch.get().QuadPart);
#endif
	}

	//--Cleanup--//
	cv::waitKey(0);

	return 0;
}

#ifndef MULTI_THREAD
void forward_projection_dot(cv::Mat &mat, cv::Mat &img, cv::Mat &angle)
{
	int c = 0;
	int count = angle.cols;
	double ang;

	img.copyTo(p(cv::Rect(round(0.5 * IMG_SIZE) - 1, round(0.5 * IMG_SIZE) - 1, img.cols, img.rows)));

#ifdef DEBUG_WINDOW
	cv::imshow("p", p);
	cv::waitKey(1);
#endif

	for (int i = 0; i < count; i++)
	{
		ang = angle.at<cv::Vec<double, 1>>(0, i)[0] + PI / 2;

		NMR3(mat(cv::Rect(i, 0, 1, IMG_SIZE)), ang);

		c++;
	}
}
#else
void forward_projection_dot(cv::Mat &mat, cv::Mat &img, cv::Mat &angle)
{
	int count = angle.cols;

	img.copyTo(p(cv::Rect(round(0.5 * IMG_SIZE) - 1, round(0.5 * IMG_SIZE) - 1, img.cols, img.rows)));

#ifdef DEBUG_WINDOW
	cv::imshow("p", p);
	cv::waitKey(1);
#endif

	DOT_WRAPPER *arr;
	THREAD_HANDLE *handle;

	arr = (DOT_WRAPPER *)calloc(THREAD_NUM, sizeof(DOT_WRAPPER));
	handle = (THREAD_HANDLE *)calloc(THREAD_NUM, sizeof(THREAD_HANDLE));

	int n = count / THREAD_NUM;

	//Create Thread Table
	for (int i = 0; i < THREAD_NUM; i++)
	{
		arr[i].mat = &mat;
		arr[i].angle = &angle;
		arr[i].count = n * i;

		if (i == THREAD_NUM - 1)
			arr[i].length = count - arr[i].count;
		else
			arr[i].length = n;
	}

	//Start Thread
	for (int i = 0; i < THREAD_NUM; i++)
	{
		if (arr[i].length == 0)
			continue;
#ifdef _WIN32
		handle[i] = CreateThread(NULL, 0, forward_projection_dot_parallel, &arr[i], 0, NULL);
#else
		pthread_create(&handle[i], NULL, forward_projection_dot_parallel, &arr[i]);
#endif
	}

	//Wait for Thread
	int status;

	for (int i = 0; i < THREAD_NUM; i++)
	{
		if (arr[i].length == 0)
			continue;
#ifdef _WIN32
		WaitForSingleObject(handle[i], INFINITE);
#else
		pthread_join(handle[i], (void **)&status);
#endif
	}

	free(arr);
	free(handle);
}
#endif
THREAD_ forward_projection_dot_parallel(LPVOID arg)
{
	DOT_WRAPPER *data = (DOT_WRAPPER *)arg;
	int count = data->angle->cols;
	double ang;

	for (int i = data->count; i< data->count + data->length; i++)
	{
		ang = data->angle->at<cv::Vec<double, 1>>(0, i)[0] + PI / 2;

		NMR3(data->mat->operator()(cv::Rect(i, 0, 1, IMG_SIZE)), ang);
	}

	return 0;
}

void NMR3(cv::Mat &RADON, double angle)
{
	double den = 0.1;
	int count = 0;
	int n;
	cv::Mat x;

	//Initialization
	n = CD_SIZE * 2 / den;
	x.create(1, n, CV_64FC1);
	for (int i = 0; i < n; i++)
		x.at<cv::Vec<double, 1>>(0, i) = CD_SIZE + den * (i + 1);

	//Calculate
	double y;
	double s, c;

	s = sin(angle);
	c = cos(angle);

	cv::Mat x_rot;
	cv::Mat y_rot;

	x_rot.create(1, n, CV_64FC1);
	y_rot.create(1, n, CV_64FC1);

	for (int k = -round(IMG_SIZE / 2); k < IMG_SIZE / 2; k++)
	{
		y = k * 1 + round(CD_SIZE * 2);	//1 is itv

		x_rot = (x - 2 * CD_SIZE) * c - (y - 2 * CD_SIZE) * s + 2 * CD_SIZE;
		y_rot = (x - 2 * CD_SIZE) * s + (y - 2 * CD_SIZE) * c + 2 * CD_SIZE;

		RADON.at<cv::Vec<double, 1>>(count, 0) = 0;

		for (int j = 0; j < n; j++)
			RADON.at<cv::Vec<double, 1>>(count, 0) += p.at<cv::Vec<double, 1>>((int)round(x_rot.at<cv::Vec<double, 1>>(0, j)[0]) - 1, (int)round(y_rot.at<cv::Vec<double, 1>>(0, j)[0]) - 1) * den;

		count++;
	}
}

//This function assumes ori_x is sorted
//new_x, out is 2D matrix
void interp1(cv::Mat &ori_x, cv::Mat &data_x, cv::Mat &new_x, cv::Mat &out)
{
	if (!out.empty())
		out.release();

	int n = ori_x.cols;	//Same as IMG_SIZE
	if (n < 0)
		return;

	cv::Mat data;

	cv::flip(ori_x, ori_x, 1);
	cv::transpose(data_x, data);

	if (data.cols != n)
		return;

	cv::Mat diff(1, n, CV_64FC1);

	//Create slope table
	for (int i = 0; i < n - 1; i++)
	{
		diff.at<cv::Vec<double, 1>>(0, i) = (data.at<cv::Vec<double, 1>>(0, i + 1)[0] - data.at<cv::Vec<double, 1>>(0, i)[0]) / (ori_x.at<cv::Vec<double, 1>>(0, i + 1)[0] - ori_x.at<cv::Vec<double, 1>>(0, i)[0]);
	}
	diff.at<cv::Vec<double, 1>>(0, n - 1) = 0;

	int nx, ny;

	nx = new_x.rows;
	ny = new_x.cols;

	out.create(nx, ny, CV_64FC1);

#ifndef MULTI_THREAD
	int idx;
	double cur;

	for (int i = 0; i < nx; i++)
	{
		for (int j = 0; j < ny; j++)
		{
			cur = new_x.at<cv::Vec<double, 1>>(i, j)[0];

			//Linear Search
			idx = -1;
			if (cur >= ori_x.at<cv::Vec<double, 1>>(0, 0)[0] && cur <= ori_x.at<cv::Vec<double, 1>>(0, ori_x.cols - 1)[0])
				for (int k = n - 1; k >= 0; k--)
					if (cur >= ori_x.at<cv::Vec<double, 1>>(0, k)[0])
					{
						idx = k;
						break;
					}

			//Interpolation
			out.at<cv::Vec<double, 1>>(i, j) = (idx == -1 ? 0 : diff.at<cv::Vec<double, 1>>(0, idx)[0] * (cur - ori_x.at<cv::Vec<double, 1>>(0, idx)[0]) + data_x.at<cv::Vec<double, 1>>(0, idx)[0]);
		}
	}
#else
	THREAD_HANDLE *handle;
	INTERP_WRAPPER *arr;

	int len = n / THREAD_NUM;

	handle = (THREAD_HANDLE *)calloc(THREAD_NUM, sizeof(THREAD_HANDLE));
	arr = (INTERP_WRAPPER *)calloc(THREAD_NUM, sizeof(INTERP_WRAPPER));

	//Create Thread Table
	for (int i = 0; i < THREAD_NUM; i++)
	{
		arr[i].ori_x = &ori_x;
		arr[i].data_x = &data_x;
		arr[i].diff = &diff;
		arr[i].new_x = &new_x;
		arr[i].out = &out;
		arr[i].idx = len * i;

		if (i == THREAD_NUM - 1)
			arr[i].length = n - arr[i].idx;
		else
			arr[i].length = len;
	}

	//Start Thread
	for (int i = 0; i < THREAD_NUM; i++)
	{
#ifdef _WIN32
		handle[i] = CreateThread(NULL, 0, interp1_parallel, &arr[i], 0, NULL);
#else
		pthread_create(&handle[i], NULL, interp1_parallel, &arr[i]);
#endif
	}

	//Wait for Thread
	int status;

	for (int i = 0; i < THREAD_NUM; i++)
	{
#ifdef _WIN32
		WaitForSingleObject(handle[i], INFINITE);
#else
		pthread_join(handle[i], (void **)&status);
#endif
	}

	free(arr);
	free(handle);
#endif
}

THREAD_ interp1_parallel(LPVOID arg)
{
	INTERP_WRAPPER *data = (INTERP_WRAPPER *)arg;
	double cur;
	int idx;
	int n = data->ori_x->cols;

	for (int i = data->idx; i < data->idx + data->length; i++)
	{
		for (int j = 0; j < IMG_SIZE; j++)
		{
			cur = data->new_x->at<cv::Vec<double, 1>>(i, j)[0];

			//Linear Search
			idx = -1;
			if (cur >= data->ori_x->at<cv::Vec<double, 1>>(0, 0)[0] && cur <= data->ori_x->at<cv::Vec<double, 1>>(0, n - 1)[0])
				for (int k = n - 1; k >= 0; k--)
					if (cur >= data->ori_x->at<cv::Vec<double, 1>>(0, k)[0])
					{
						idx = k;
						break;
					}

			//Interpolation
			data->out->at<cv::Vec<double, 1>>(i, j) = (idx == -1 ? 0 : data->diff->at<cv::Vec<double, 1>>(0, idx)[0] * (cur - data->ori_x->at<cv::Vec<double, 1>>(0, idx)[0]) + data->data_x->at<cv::Vec<double, 1>>(0, idx)[0]);
		}
	}

	return 0;
}