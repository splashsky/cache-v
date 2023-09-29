module cache

fn test_foobar() {
	mut c := Cache.new[string](10)
	c.set("foo", "bar")
	assert c.get("foo") == "bar"
}

fn test_overflow() {
	mut c := Cache.new[string](2)
	c.set("foo", "bar")
	c.set("bar", "baz")
	c.set("baz", "qux")
	assert c.get("foo") == ""
	assert c.get("bar") == "baz"
	assert c.get("baz") == "qux"
}

fn test_lru() {
	mut c := Cache.new[string](3)
	c.set("foo", "bar")
	c.set("bar", "baz")
	c.set("baz", "qux")

	println(c)

	test := c.get("foo")
	println(c)
	c.set("qux", "quux")


	assert c.get('bar') == ''
	assert test == 'bar'
	assert c.get('baz') == 'qux'
	assert c.get('qux') == 'quux'
}
