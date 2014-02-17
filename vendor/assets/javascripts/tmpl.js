$(document).ready(function() {

  function TmplContainerNotDefinedError() {
    this.name = "TmplContainerNotDefined Error";
    this.message = "Tmpl could not locate a container.";
  }
  TmplContainerNotDefinedError.prototype = new Error();
  TmplContainerNotDefinedError.prototype.constructor = TmplContainerNotDefinedError;

  function TmplTmplNotFoundError() {
    this.name = "TmplTmplNotFound Error";
    this.message = "Tmpl could not find a .tmpl element.";
  }
  TmplTmplNotFoundError.prototype = new Error();
  TmplTmplNotFoundError.prototype.constructor = TmplTmplNotFoundError;

  function TmplKeyNotFoundError(key) {
    this.name = "TmplContainerNotFound Error";
    this.message = 'Tmpl could not find a key matching: \'' + key + '\'';
  }
  TmplKeyNotFoundError.prototype = new Error();
  TmplKeyNotFoundError.prototype.constructor = TmplKeyNotFoundError;

  $(document).on('click', 'form .tmpl-add', function() {
    var $this       = $(this);                      // link clicked
    var time        = new Date().getTime();         // current time
    var template    = $this.data('tmpl');           // template name
    var $template   = $('#' + template + '_tmpl');  // template
    var $content    = $($template.html().trim());   // parsed template content

    // $ container (to add elements to)
    if ($this.data('tmpl-container') !== undefined) {
      var $container = $($this.data('tmpl-container') + ':visible');  // from container option
    } else {
      var $container = $($this.parents('.tmpl-container')[0]);        // if link is within container
      // TODO make it just start with tmpl-container
    }
    if ($container.length === 0) throw new TmplContainerNotDefinedError();

    var key           = '\\w+_attributes';            // default key - RegExp escaping
    if ($template.data('tmpl-key') !== undefined) {
      key             = $template.data('tmpl-key'); // key from template option
    }
    var keyRegExp         = new RegExp('.*\\[' + key + '\\]\\[\\d*\\]');

    // $ tmpl
    var _match        = null;
    var indexRegExp   = new RegExp('\\[(\\w+)\\]\\[(\\d+)\\]', 'g');
    var stemIndexes   = {};
    var indexes       = {};
    var $tmpl         = $($container.parents('.tmpl')[0]).data('index', true);
    var $templateTmpl = $template.find('.tmpl:first');
    if ($tmpl.length === 0) {
      $tmpl = $templateTmpl;
      $tmpl.removeData('index');
    }
    if ($tmpl.length === 0) throw new TmplTmplNotFoundError();

    var $context      = $($tmpl.find('input,select,textarea')[0]);  // context element
    var context       = $context.prop('name');                      // context element name
    if ($tmpl.data('index')) {
      _match = null;
      while((_match = indexRegExp.exec(context)) !== null) {
        indexes[_match[1]] = _match;
      }
    }

    var $templateContext  = $($templateTmpl.find('input,select,textarea')[0]);  // template context element
    var templateContext   = $templateContext.prop('name');                      // template context element name
    var keyMatch          = templateContext.match(keyRegExp);                   // match of key with index
    if (keyMatch === null) throw new TmplKeyNotFoundError(key);
    var stem              = keyMatch[0];

    // find all stem indexes
    _match = null;
    while((_match = indexRegExp.exec(stem)) !== null) {
      stemIndexes[_match[1]] = _match;
    }

    // replace all indexes with either value from indexes obj or time.
    for (var _key in stemIndexes) {
      var stemMatch     = stemIndexes[_key];
      var indexMatch    = indexes[_key];
      var index         = (indexMatch) ? indexMatch[2] : time;
      var match         = '[' + stemMatch[1] + '][' + index + ']';
      stem = stem.replace(stemMatch[0], match);
    }

    var $inputs     = $content.find('input[name],textarea[name],select[name]');
    $inputs.each(function(idx, element){
      var $element  = $(element);
      var name      = $element.prop('name');
      var tail      = name.match(new RegExp('\\[' + key + '\\]\\[\\d+\\](.*)'))[1];
      name          = stem + tail;
      var id        = name.replace(/]/g, '').replace(/\[/g, '_');
      $element.prop('name', name);
      $element.prop('id', id);
      // TODO also replace label for
    });

    $content.find('[class^=tmpl-container-]').each(function(idx, element){
      var $element  = $(element);
      $.each($element.prop('class').split(' '), function(idx, cls) {
        var match = cls.match(new RegExp('^tmpl-container-(.*)-\\d+$'));
        if (match !== null) {
          $element.removeClass(cls);
          $element.addClass('tmpl-container-' + match[1] + '-' + time);
        }
      });
    });
    $content.find('a.tmpl-add[data-tmpl-container^=".tmpl-container-"]').each(function(idx, element){
      var $element  = $(element);
      dataContainer = $element.data('tmpl-container');
      var match = dataContainer.match(new RegExp('^\.tmpl-container-(.*)-\\d+$'));
      if (match !== null) {
        var newDataContainer = '.tmpl-container-' + match[1] + '-' + time;
        $element.attr('data-tmpl-container', newDataContainer);
        $element.data('tmpl-container', newDataContainer);
      }
    });

    $container.append($content);
  });

  $(document).on('click', 'form .tmpl-remove', function() {
    var $this = $(this);
    var $tmpl = $($this.parents('.tmpl')[0]);
    var $destroy = $($tmpl.find('input[type=hidden][name$="[_destroy]"]')[0]);
    if ($destroy.length > 0) $destroy.val('1').change();
    $tmpl.hide();
  });

});
