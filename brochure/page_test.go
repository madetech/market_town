package brochure

import (
	"encoding/json"
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

func TestPageToJSON(t *testing.T) {
	pageID, _ := PageIDFromURI("//madetech.com/blog/a-blog-post?locale=en-GB")

	page := &Page{
		Id:       pageID,
		Release:  PageRelease{100, "f5826bba-4496-4361-a061-e8b76ec0971d"},
		Contents: []PageContent{},
	}

	pageJSON := convertPageToJSONString(page)
	assert.Contains(t, pageJSON, `"host":"madetech.com"`)
	assert.Contains(t, pageJSON, `"path":"/blog/a-blog-post"`)
	assert.Contains(t, pageJSON, `"locale":"en-GB"`)
	assert.Contains(t, pageJSON, `"uri":"//madetech.com/blog/a-blog-post?locale=en-GB"`)
	assert.Contains(t, pageJSON, `"timestamp":100`)
	assert.Contains(t, pageJSON, `"uuid":"f5826bba-4496-4361-a061-e8b76ec0971d"`)
	assert.Contains(t, pageJSON, `"contents":[]`)
}

func convertPageToJSONString(page *Page) string {
	pageJSON, _ := json.Marshal(page)
	return string(pageJSON)
}
