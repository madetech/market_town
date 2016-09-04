package brochure

import (
	"encoding/json"
	"net/http"
)

type indexPageRequest struct {
	Page indexPageRequestPage `json:"page"`
}

type indexPageRequestPage struct {
	Page
}

func IndexPageRequest(request http.Request) (indexPageRequest, error) {
	decoder := json.NewDecoder(request.Body)
	var indexPageRequest indexPageRequest
	err := decoder.Decode(&indexPageRequest)
	return indexPageRequest, err
}
