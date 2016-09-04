package brochure

import (
	"encoding/json"
	"fmt"
	"log"
	"net/url"
)

type Page struct {
	Id       pageID        `json:"id"`
	Release  PageRelease   `json:"release"`
	Contents []PageContent `json:"contents"`
}

func (page Page) JSON() []byte {
	pageJSON, err := json.Marshal(page)

	if err != nil {
		log.Fatal(err)
	}

	return pageJSON
}

type pageID struct {
	Host   string `json:"host"`
	Path   string `json:"path"`
	Locale string `json:"locale"`
	URI    string `json:"uri"`
}

func PageID(host string, path string, locale string) pageID {
	uri := fmt.Sprintf("//%s%s?locale=%s", host, path, locale)
	return pageID{host, path, locale, uri}
}

func PageIDFromURI(uri string) pageID {
	u, err := url.Parse(uri)

	if err != nil {
		log.Fatal(err)
	}

	return pageID{u.Host, u.Path, u.Query().Get("locale"), uri}
}

type PageRelease struct {
	Timestamp int    `json:"timestamp"`
	UUID      string `json:"uuid"`
}

type PageContent map[string]interface{}
