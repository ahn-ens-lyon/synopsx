function buttons() {
  var forms = document.getElementsByTagName("form");
  for(var f = 0; f < forms.length; f++) {
    var form = forms[f];
    if(form.className != 'update') continue;

    var inputs = form.getElementsByTagName("input");
    var c = 0;
    for(var i = 0; i < inputs.length; i++) {
      if(inputs[i].type == "checkbox" && inputs[i].checked) c++;
    }
    var buttons = form.getElementsByTagName("button");
    for(var i = 0; i < buttons.length; i++) {
      var button = buttons[i], n = button.className, s = button.value, e = !button.disabled;
      if(n == 'global') continue;

      if(s == "optimize" || s == "optimize-all" || s == "drop" || s == "drop-backup" || s == "restore" ||
         s == "backup" || s == "delete" || s == "delete-log" || s == "delete-log" || s == "kill") {
        e = c > 0;
      }
      button.disabled = !e;
    }
  }
};

function setInfo(message) {
  var i = document.getElementById("info");
  i.className = 'info';
  i.innerText = message;
};

function setWarning(message) {
  var i = document.getElementById("info");
  i.className = 'warning';
  i.innerText = message;
};

function setError(message) {
  var i = document.getElementById("info");
  i.className = 'error';
  i.innerText = message;
};

var searchDelay = 200;
var _d;
function query(wait, success, key, query, enforce, target) {
  var d = new Date();
  _d = d;
  setTimeout(function() {
    if(_d != d) return;

    var name = document.getElementById("name");
    var resource = document.getElementById("resource");
    var sort = document.getElementById("sort");
    var loglist = document.getElementById("loglist");
  
    if(wait) setWarning(wait);
    var req = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");
    req.onreadystatechange = function() {
      if(req.readyState == 4) {
        if(req.status == 200) {
          target(req.responseText);
          if(success) setInfo(success);
        } else {
          setError(req.statusText.replace(/^.*?\] /, ''));
        }
      }
    };
    // synchronous querying: wait for server feedback
    req.open("POST", key +
      "?name=" + encodeURIComponent(name ? name.value : "") +
      "&resource=" + encodeURIComponent(resource ? resource.value : "") +
      "&sort=" + encodeURIComponent(sort ? sort.value : "") +
      "&loglist=" + encodeURIComponent(loglist ? loglist.value : "") +
      "&query=" + encodeURIComponent(query), true);
    req.send(null);
  }, enforce ? 0 : searchDelay);
};

var _list;
function logslist(wait, success) {
  var input = document.getElementById('loglist').value.trim();
  if(_list == input) return false;
  _list = input;
  query(wait, success, 'loglist', input, false, function(text) {
    document.getElementById("list").innerHTML = text;
  })
};

var _logs;
function logentries(wait, success) {
  var input = document.getElementById('logs').value.trim();
  if(_logs == input) return false;
  _logs = input;
  query(wait, success, 'logs', input, false, function(text) {
    document.getElementById("output").innerHTML = text;
  })
};

var _query;
function xpath(wait, success) {
  var input = document.getElementById('xquery').value.trim();
  if(_query == input) return false;
  _query = input;
  query(wait, success, 'xquery', input, false, function(text) {
    document.getElementById("output").value = text;
  })
};

var _xquery;
function xquery(wait, success, enforce) {
  var realtime = document.getElementById("realtime").checked;
  document.getElementById("run").disabled = realtime;

  var input = document.getElementById('xquery').value;
  if(enforce || (realtime && _xquery != input)) {
    _xquery = input;
    query(wait, success, 'queries', input, enforce, function(text) {
      document.getElementById("output").value = text;
    })
  }
};
