package main
import (
	"context"
	"fmt"
	"net"
	auth_pb "github.com/envoyproxy/go-control-plane/envoy/service/auth/v3"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)
var (
	localEndpointURI = "0.0.0.0:10004"
)
type service struct{}
func (s *service) Check(ctx context.Context, r *auth_pb.CheckRequest) (*auth_pb.CheckResponse, error) {
	fmt.Println("received check request")
	// We can getch source IP from r.
	fmt.Println(r)

	// Other metadata can be fethed from context metadata.
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return nil, status.Errorf(codes.DataLoss, "failed to get metadata")
	}
	fmt.Println(md)

	// return nil, fmt.Errorf("error")
	// Returns Ok status
	return &auth_pb.CheckResponse{}, nil
}
func main() {
	grpcServer := grpc.NewServer()
	lis, err := net.Listen("tcp", localEndpointURI)
	if err != nil {
		panic(err)
	}
	s := &service{}
	auth_pb.RegisterAuthorizationServer(grpcServer, s)
	fmt.Println("Starting the ext authz server...")
	grpcServer.Serve(lis)
}