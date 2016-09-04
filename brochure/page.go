package brochure

import (
	"fmt"
	"net/url"
)

type Page struct {
	Id       *pageID       `json:"id"`
	Release  PageRelease   `json:"release"`
	Contents []PageContent `json:"contents"`
}

type pageID struct {
	Host   string `json:"host"`
	Path   string `json:"path"`
	Locale string `json:"locale"`
	URI    string `json:"uri"`
}

func PageID(host string, path string, locale string) *pageID {
	uri := fmt.Sprintf("//%s%s?locale=%s", host, path, locale)
	return &pageID{host, path, locale, uri}
}

func PageIDFromURI(uri string) (*pageID, error) {
	u, err := url.Parse(uri)

	if err != nil {
		return nil, err
	}

	return &pageID{u.Host, u.Path, u.Query().Get("locale"), uri}, nil
}

type PageRelease struct {
	Timestamp int    `json:"timestamp"`
	UUID      string `json:"uuid"`
}

type PageContent map[string]interface{}
