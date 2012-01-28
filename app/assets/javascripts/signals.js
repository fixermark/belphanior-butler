// Copyright 2011 Mark T. Tomczak
//
// See the README file for license information

// TODO(mtomczak): This should probably be a jQuery extension

function Handle(signal, handler) {
  return $(document).bind(signal, function(event, data) {
      handler(data);
  });
}

function Signal(signal, data) {
  return $(document).trigger(signal, [data]);
}