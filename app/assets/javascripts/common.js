
$(function(){
  $('[data-toggle="tooltip"]').tooltip({ trigger: 'hover', placement: 'bottom', html: true })
  $('[data-toggle="popover"]').popover({ trigger: 'hover', placement: 'bottom', html: true })
  $('[rel="tooltip"]').tooltip({ trigger: 'hover', placement: 'bottom', html: true })
  $('[rel="popover"]').popover({ trigger: 'hover', placement: 'bottom', html: true })

  // aタグにtarget=blank指定
  $('.target_blank a').attr('target' , '_blank');

  // オートページャー有効フラグ
  if ($('#autopager_on').val() == 'true') {
    autopager();

    // 初期状態で2ページ目を読み込む(ディスプレイの縦幅が大きい場合スクロールバーが表示されないため)
    add_page($(this));
  };
});

// オートページャー
function autopager() {
  $(window).scroll(function() {
    var obj = $(this);
    var current = $(window).scrollTop() + window.innerHeight;
    if (current < $(document).height() - 400) return;  // 下部に達していなければリターン
    if (obj.data('loading')) { return };               // ロード中であればリターン

    add_page(obj);
  });
}

function add_page(obj) {
  // パラメータ
  var target_month = $('#target_month').val();
  var next_month   = $('#next_month_' + target_month).val();
  var page         = parseInt($('#current_page').val());
  var next_page    = page + 1

  obj.data('loading', true);  // ローディングフラグON
  $.get(
    "/schedules/pager",
    // 送信データ
    { 'target_month': target_month, 'page': page },
    function(data, status) {
      $('#page_' + page).after(data);     // データ追加
      $('#current_page').val(next_page);  // ページ数更新
      obj.data('loading', false);         // ローディングフラグOFF

      $('a[rel=tooltip]').tooltip( { html: true, placement: 'bottom', trigger: 'hover' } );
      $('a[rel=popover]').popover( { html: true, placement: 'bottom', trigger: 'hover' } );
    },
    "html"                                // 応答データ形式
  );
}
