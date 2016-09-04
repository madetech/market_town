package brochure

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPageIDFromURI(t *testing.T) {
	pageID := PageIDFromURI("//madetech.com/blog/a-blog-post?locale=en-GB")
	assert.Equal(t, "madetech.com", pageID.Host)
	assert.Equal(t, "/blog/a-blog-post", pageID.Path)
	assert.Equal(t, "en-GB", pageID.Locale)
}

func TestPageIDBuildsURI(t *testing.T) {
	pageID := PageID("madetech.com", "/blog/a-blog-post", "en-GB")
	assert.Equal(t, "//madetech.com/blog/a-blog-post?locale=en-GB", pageID.URI)
}

func TestPageToJSON(t *testing.T) {
	page := Page{
		Id:       PageIDFromURI("//madetech.com/blog/a-blog-post?locale=en-GB"),
		Release:  PageRelease{},
		Contents: []PageContent{},
	}

	assert.Contains(t, string(page.JSON()), `"host":"madetech.com"`)
	assert.Contains(t, string(page.JSON()), `"path":"/blog/a-blog-post"`)
	assert.Contains(t, string(page.JSON()), `"locale":"en-GB"`)
	assert.Contains(t, string(page.JSON()), `"uri":"//madetech.com/blog/a-blog-post?locale=en-GB"`)
}
