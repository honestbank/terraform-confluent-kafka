package test

type cluster struct {
	Spec   clusterSpec   `json:"spec"`
	Status clusterStatus `json:"status"`
}

type clusterStatus struct {
	Phase string `json:"phase"`
}

type clusterSpec struct {
	DisplayName  string `json:"display_name"`
	Availability string `json:"availability"`
	Cloud        string `json:"cloud"`
	Region       string `json:"region"`
}

type topic struct {
	PartitionsCount int `json:"partitions_count"`
}

type serviceAccount struct {
	Kind       string `json:"kind"`
	ApiVersion string `json:"api_version"`
}
