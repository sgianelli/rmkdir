#!/usr/bin/env ruby

if ARGV.length == 0
  p "No arguments specified"
  exit -1
end

options = ARGV.select { |arg| arg[0] == "-" }
paths = ARGV.select { |arg| arg[0] != "-" }

pflag = options.include? "-p"

paths.each { |path|
  `mkdir #{pflag ? "-p" : ""} #{path}`

  tip = path.split('/').last
  name = tip[0].upcase + tip[1..-1]

  packagePath = File.join(path, "package.json")
  jsPath = File.join(path, "#{name}.jsx")
  scssPath = File.join(path, "#{name}.scss")

  json = "{ \\\"name\\\": \\\"#{name}\\\", \\\"version\\\": \\\"0.0.0\\\", \\\"private\\\": true, \\\"main\\\": \\\"./#{name}.jsx\\\" }"

  `echo "#{json}" | jq . > #{packagePath}`

  rx = "import React, { Component } from 'react';
import { Link } from 'react-router';

import './#{name}.scss';

export default class #{name} extends Component {

    constructor(props) {
        super(props);

        this.state = {};
    }

    componentWillMount() {

    }

    render() {
        return (<div className=\"#{name}\">

        </div>);
    }
}"

  scss = "\n.#{name} {\n\n}"

  File.open(jsPath, 'w') { |file| file.write(rx) }
  File.open(scssPath, 'w') { |file| file.write(scss) }
}
