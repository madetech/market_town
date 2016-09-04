package brochure

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPageIDFromURI(t *testing.T) {
	pageID := PageIDFromURI("//madetech.com/blog/a-blog-post?locale=en-GB")
	assert.Equal(t, pageID.Host(), "madetech.com")
	assert.Equal(t, pageID.Path(), "/blog/a-blog-post")
	assert.Equal(t, pageID.Locale(), "en-GB")
}
