module cache

/*
	The cache is a very simple key-value store, where the key is a
	string and the value is arbitrarily assigned at creation.

	In order to apply an LRU policy to limit the size of the cache,
	we keep a buffer of keys that have been accessed, and when the
	cache is full, we evict the least recently used key.

	When a key is accessed, we move it to the end of the buffer.
	When a key is added, we add it to the end of the buffer.
	When a key is evicted, we remove it from the front of the buffer.
*/

struct Cache[T] {
	capacity int

	mut:
	cache map[string]T
	head string
	tail string
}

// Create a new cache with type T and given capacity.
fn Cache.new[T](capacity int) Cache[T] {
	return Cache[T]{
		capacity: capacity,
		cache:    map[string]T{},
	}
}

// Add a value to the cache, evicting the least recently used key if
// the cache is full.
fn (mut c Cache[T]) set(key string, value T) {
	if c.cache.len == 0 {
		c.tail = key
		c.head = key
	} else {
		c.head = key
	}

	if c.cache.len == c.capacity {
		c.cache.delete(c.tail)
		c.tail = c.cache.keys()[0]
	}

	c.cache[key] = value
}

// Get a value from the cache, and move the key to the end of the buffer.
fn (mut c Cache[T]) get(key string) T {
	c.head = key

	if c.head == c.tail {
		value := c.cache[c.head]
		c.cache.delete(c.head)
		c.cache[c.head] = value
		c.tail = c.cache.keys()[0]
	}

	return c.cache[key]
}
