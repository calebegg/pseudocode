(function() {
  /*
  Caleb Eggensperger
  */  var blink, gel, index, main, regex_rules, rules, sub, update;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  rules = (function() {
    var _len, _ref, _results;
    _ref = ['==', '!=', '<=', '>=', '<<', '>>', '&&', '||', '->', '\\b', '\\t', '\\n', '\\ ', '\\"', "\\'", '\\\\', '/*', '*/', '//', '"""', "'''", '///', '()', '[]', '{}', '<', '>', '!', '0x', '::', '='];
    _results = [];
    for (index = 0, _len = _ref.length; index < _len; index++) {
      sub = _ref[index];
      _results.push([sub, String.fromCharCode(0xE000 + index)]);
    }
    return _results;
  })();
  regex_rules = [
    [/"(.*?)"/g, '\u201C$1\u201D'], [/(^|\W|\b[ru])'(.*?)'($|\W)/g, '$1\u2018$2\u2019$3'], [/\uE019\s/g, '< '], [/\s\uE01A/g, ' >'], [
      /\b([a-zA-Z]\w*?)([0-9]+)\b/g, function(_, varname, num) {
        var digit;
        return varname + ((function() {
          var _i, _len, _ref, _results;
          _ref = num.split('');
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            digit = _ref[_i];
            _results.push(String.fromCharCode(parseInt(digit) + 0x2080));
          }
          return _results;
        })()).join('');
      }
    ], [/[\w#]\ue01b/g, '$1' + '!'], [/&/g, '&amp;'], [/</g, '&lt;'], [/>/g, '&gt;'], [/ /g, '&nbsp;'], [/\n/g, '<br />']
  ];
  gel = function(id) {
    return document.getElementById(id);
  };
  main = function() {
    setTimeout(update, 100);
    return setInterval(blink, 500);
  };
  blink = function() {
    var cursor;
    cursor = gel('cursor');
    if (!(cursor != null)) {
      return;
    }
    if (cursor.style.background === 'black') {
      return cursor.style.background = 'white';
    } else {
      return cursor.style.background = 'black';
    }
  };
  update = function() {
    var code, end, find, i, idx, input, maybe_find, maybe_repl, new_part, part, parts, repl, rule, start, substrs, x, _i, _j, _len, _len2, _len3, _ref;
    input = gel('input');
    code = input.value;
    start = input.selectionStart;
    end = input.selectionEnd;
    parts = [code.substring(0, start), code.substring(start, end), code.substring(end, code.length)];
    for (idx = 0, _len = parts.length; idx < _len; idx++) {
      part = parts[idx];
      new_part = [];
      i = 0;
      while (i < part.length) {
        substrs = (function() {
          var _results;
          _results = [];
          for (x = 1; x <= 3; x++) {
            _results.push(part.substr(i, x));
          }
          return _results;
        })();
        maybe_find = null;
        for (_i = 0, _len2 = rules.length; _i < _len2; _i++) {
          rule = rules[_i];
          find = rule[0], repl = rule[1];
          if (find === null) {
            continue;
          }
          if (__indexOf.call(substrs, find) >= 0 && (maybe_find === null || find.length > maybe_find.length)) {
            maybe_find = rule[0], maybe_repl = rule[1];
          }
        }
        if (maybe_find != null) {
          new_part.push(maybe_repl);
          i += maybe_find.length;
        } else {
          new_part.push(substrs[0]);
          i++;
        }
      }
      parts[idx] = new_part.join('');
      for (_j = 0, _len3 = regex_rules.length; _j < _len3; _j++) {
        rule = regex_rules[_j];
        parts[idx] = (_ref = parts[idx]).replace.apply(_ref, rule);
      }
    }
    code = parts[0] + (focused ? '<span id="highlight">' : '') + parts[1] + (focused ? '</span><span id="cursor"></span>' : '') + parts[2];
    return gel('display').innerHTML = code;
  };
  window.main = main;
  window.update = update;
  window.focused = false;
}).call(this);
