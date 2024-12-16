#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables
DOC_VERSION="$1"
GO_VERSION="1.23.1"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
PARSER_DIR="/home/build/cassandra-website/cqlprotodoc"
WEBSITE_DIR="/home/build/cassandra-website"
CASSANDRA_DIR="/home/build/cassandra"

# Step 0: Download and install Go
echo "Downloading Go $GO_VERSION..."
wget -q https://golang.org/dl/$GO_TAR

echo "Installing Go..."
tar -C /usr/local -xzf $GO_TAR

# Set Go environment variables
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

# Step 1: Building the parser
echo "Building the cqlprotodoc..."
cd "$PARSER_DIR"
go build -o cqlprotodoc

# Step 2: Process the spec files using the parser
echo "Processing the .spec files..."
"$PARSER_DIR"/cqlprotodoc "$CASSANDRA_DIR/doc" "$WEBSITE_DIR/site-content/build/html/Cassandra/$DOC_VERSION/cassandra/native-protocol"

# Step 3: Cleanup - Remove the Cassandra and parser directories
echo "Cleaning up..."
rm -rf "$PARSER_DIR/cqlprotodoc" "$PARSER_DIR/specs" /usr/local/go $GO_TAR

echo "Script completed successfully."
