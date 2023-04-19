{
  project.name = "webserver";
  services.webserver = {
    service.image = "nginx";
    service.ports = [ "80:80" ];
  };
}
