{
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "localsend-cli";
  version = "0.1.1";

  pyproject = true;

  src = python3Packages.fetchPypi {
    pname = "localsend_cli";
    inherit version;
    hash = "sha256-N8lO9Hrrwwriaq6mJMP6T4CeZy5m0tPqUIvRvi5dcvw=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    cryptography
  ];

  postPatch = ''
    sed -i \
      '/^from \.\.crypto import ensure_cert$/a from ..constants import CERT_FILE, KEY_FILE' \
      localsend_cli/commands/send.py

    sed -i \
      '/^    session\.verify = False$/a\    session.cert = (str(CERT_FILE), str(KEY_FILE))' \
      localsend_cli/commands/send.py
  '';

  doCheck = false;

  meta = {
    description = "Command-line implementation of LocalSend";
    homepage = "https://pypi.org/project/localsend-cli/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "localsend-cli";
  };
}
