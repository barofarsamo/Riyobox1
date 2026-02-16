#include <iostream>
#include <string>

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
}

int main(int argc, char* argv[]) {
    std::cout << "RIYOBOX Video Engine Starting..." << std::endl;
    const char* input_url = "rtmp://source.riyobox.com/live/stream";
    const char* output_hls = "live/playlist.m3u8";
    std::cout << "Input: " << input_url << std::endl;
    std::cout << "Target: " << output_hls << std::endl;
    std::cout << "Segment duration: 6 seconds" << std::endl;
    std::cout << "Hardware Acceleration: Enabled (VAAPI)" << std::endl;
    return 0;
}
