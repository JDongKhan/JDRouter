//
//  main.m
//  JDRouter
//
//  Created by 王金东 on 2016/1/27.
//  Copyright © 2016年 王金东. All rights reserved.
//
#import <dlfcn.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "fishhook.h"

static int (*orig_close)(int);
static int (*orig_open)(const char *, int, ...);

void save_original_symbols() {
    orig_close = dlsym(RTLD_DEFAULT, "close");
    orig_open = dlsym(RTLD_DEFAULT, "open");
}

int my_close(int fd) {
    printf("Calling real close(%d)\n", fd);
    return orig_close(fd);
}

int my_open(const char *path, int oflag, ...) {
    va_list ap = {0};
    mode_t mode = 0;
    
    if ((oflag & O_CREAT) != 0) {
        // mode only applies to O_CREAT
        va_start(ap, oflag);
        mode = va_arg(ap, int);
        va_end(ap);
        printf("Calling real open('%s', %d, %d)\n", path, oflag, mode);
        return orig_open(path, oflag, mode);
    } else {
        printf("Calling real open('%s', %d)\n", path, oflag);
        return orig_open(path, oflag, mode);
    }
}


int main(int argc, char * argv[]) {
    @autoreleasepool {
        save_original_symbols();
        //fishhook用法
        rebind_symbols((struct rebinding[2]){{"close", my_close}, {"open", my_open}}, 2);
        
        // Open our own binary and print out first 4 bytes (which is the same
        // for all Mach-O binaries on a given architecture)
        int fd = open(argv[0], O_RDONLY);
        uint32_t magic_number = 0;
        read(fd, &magic_number, 4);
        printf("Mach-O Magic Number: %x \n", magic_number);
        close(fd);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
