#---
# Excerpted from "Ruby Performance Optimization",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/adrpo for more book information.
#---
data = "x"*1024*1024*10; nil
buffers = []
GC.start
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[0] = data.dup; buffers[0][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[1] = data.dup; buffers[1][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[2] = data.dup; buffers[2][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[3] = data.dup; buffers[3][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[4] = data.dup; buffers[4][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[5] = data.dup; buffers[5][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[6] = data.dup; buffers[6][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[7] = data.dup; buffers[7][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[8] = data.dup; buffers[8][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
buffers[9] = data.dup; buffers[9][0] = 'a'; nil
[GC.stat[:count], GC.stat[:malloc_increase_bytes], GC.stat[:malloc_increase_bytes_limit]]
