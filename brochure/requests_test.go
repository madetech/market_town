package brochure

import (
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	"net/http"
	"strings"
	"testing"
)

func TestIndexPageRequest(t *testing.T) {
	req, _ := IndexPageRequest(createMockRequest(`{
		"page": {
			"id": {
				"uri": "//madetech.com/?locale=en-GB"
			},
			"release": {
				"timestamp": 1000,
				"uuid": "f5826bba-4496-4361-a061-e8b76ec0971d"
			}
		}
	}`))

	assert.Equal(t, "madetech.com", req.Page.Id.Host)
	assert.Equal(t, "/", req.Page.Id.Path)
	assert.Equal(t, "en-GB", req.Page.Id.Locale)
	assert.Equal(t, 1000, req.Page.Release.Timestamp)
	assert.Equal(t, "f5826bba-4496-4361-a061-e8b76ec0971d", req.Page.Release.UUID)
}

func createMockRequest(jsonBody string) http.Request {
	return http.Request{Body: ioutil.NopCloser(strings.NewReader(jsonBody))}
}
