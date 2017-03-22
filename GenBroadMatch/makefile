CC = g++
#Using -Ofast instead of -O3 might result in faster code, but is supported only by newer GCC versions
CFLAGS = -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result
all: query-bidterm-distance 
query-bidterm-distance: query-bidterm-distance.cpp
	$(CC) query-bidterm-distance.cpp -o query-bidterm-distance $(CFLAGS)
clean:
	rm -f query-bidterm-distance.o query-bidterm-distance
