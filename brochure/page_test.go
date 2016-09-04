package brochure

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPageIDBuildsURI(t *testing.T) {
	pageID := PageID("madetech.com", "/blog/a-blog-post", "en-GB")
	assert.Equal(t, "//madetech.com/blog/a-blog-post?locale=en-GB", pageID.URI)
}

func TestPageIDFromURI(t *testing.T) {
	pageID, _ := PageIDFromURI("//madetech.com/blog/a-blog-post?locale=en-GB")
	assert.Equal(t, "madetech.com", pageID.Host)
	assert.Equal(t, "/blog/a-blog-post", pageID.Path)
	assert.Equal(t, "en-GB", pageID.Locale)
}

func TestPageIDFromURIReturnsErrorWhenGivenInvalidURI(t *testing.T) {
	_, err := PageIDFromURI("//%01.com")
	assert.NotNil(t, err)
}
