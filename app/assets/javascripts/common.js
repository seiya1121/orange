
$(function(){
  $('[data-toggle="tooltip"]').tooltip({ trigger: 'hover', placement: 'bottom', html: true })
  $('[data-toggle="popover"]').popover({ trigger: 'hover', placement: 'bottom', html: true })
  $('[rel="tooltip"]').tooltip({ trigger: 'hover', placement: 'bottom', html: true })
  $('[rel="popover"]').popover({ trigger: 'hover', placement: 'bottom', html: true })

  // aタグにtarget=blank指定
  $('.target_blank a').attr('target' , '_blank');

  // if ($('#autopager_on').val() == 'true') { autopager(); };

  // // 初期状態で2ページ目を読み込む(ディスプレイの縦幅が大きい場合スクロールバーが表示されないため)
  // add_page($(this));
});
