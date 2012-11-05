## Belphanior Butler

Belphanior Butler is a command and control program for a Belphanior home automation network.

Features:
* Remembers location of servants.
* Documentation for roles supported by servants.
* Creation of scripts in [Ruby](http://www.ruby-lang.org) and [Blockly](http://code.google.com/p/blockly/)
  scripting environments.
* Definition of simple command buttons for quick access to scripts.
* Support for the ["commandable" servant role](http://belphanior.net/roles/commandable/v1),
  so that other servants (such as
  [the calendar watcher](http://github.com/fixermark/belphanior-calendar-watcher-servant)
  may trigger scripts in the butler.

## Getting Started

Belphanior Butler is a Rails app that has been tested in development mode.
To start, clone this repository and run the following in the cloned directory

    bundle install                                             # Installs the dependent gems
    rake db:migrate                                            # Sets up the database
    script/backgroundrb start                                  # Starts the servant watcher
    script/rails server --environment=development --port=3000  # Start the butler

The butler should now be running on localhost:3000. To test, navigate to localhost:3000
in your browser and you should see the control panel tab.

## System Information

Belphanior butler has been tested on Ubuntu 10.04 LTS and Debian GNU/Linux 6.0
(Kirkwood, on the [SheevaPlug](http://www.globalscaletechnologies.com/p-46-sheevaplug-dev-kit.aspx)
hardware platform).

## License

Belphanior Butler is licensed under the Apache license 2.0. See the LICENSE file for more details.

## For More Information

Consult the [project home page](http://belphanior.net).