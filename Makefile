BUILD = .build

all: test

test: $(BUILD)/test.ok
	# All tests passed

ref: test/test.ref $(BUILD)/test.res
	meld $^

$(BUILD)/test.ok: test/test.ref $(BUILD)/test.res
	diff $^ || ( rm -f $@; false )
	touch $@

$(BUILD)/test.res: lcpp.lua test/test.lua test/inc/foo.h test/inc/bar.h
	mkdir -p $(dir $@)
	lua test/test.lua > $@
