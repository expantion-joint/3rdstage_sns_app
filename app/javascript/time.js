// 残り時間を計算、表示するためのjavascript
document.addEventListener("DOMContentLoaded", function() {
    const EndTime = document.getElementById('EndTime');
    EndTime.addEventListener('change', showCountdown );

    // 初回起動
    showCountdown();
    // 1秒ごとに実行
    setInterval(showCountdown ,1000);
  });

function showCountdown() {
  var nowDate = new Date();          //現在日時を取得
  var dnumNow = nowDate.getTime();   //秒に変換

  var endTime  = new Date(document.getElementById("EndTime").value);
  var dnumTarget = endTime.getTime();
 
  var diff2Dates = dnumTarget - dnumNow;
  if( dnumTarget < dnumNow ) {
    // 期限が過ぎた場合は -1 を掛けて正の値に変換
    diff2Dates *= -1;
  }

  var dDays  = diff2Dates / ( 1000 * 60 * 60 * 24 );   // 日数
  diff2Dates = diff2Dates % ( 1000 * 60 * 60 * 24 );   // 余り
  var dHour  = diff2Dates / ( 1000 * 60 * 60 );   // 時間
  diff2Dates = diff2Dates % ( 1000 * 60 * 60 );   // 余り
  var dMin   = diff2Dates / ( 1000 * 60 );   // 分
  diff2Dates = diff2Dates % ( 1000 * 60 );   // 余り
  var dSec   = diff2Dates / 1000;   // 秒
  var msg2   = Math.floor(dDays) + "日"
             + Math.floor(dHour) + "時間"
             + Math.floor(dMin) + "分"
             + Math.floor(dSec) + "秒";

  // 表示文字列の作成
  var msg;
  if( dnumTarget > dnumNow ) {
    // まだ期限が来ていない場合
    msg = "終了まで、あと" + msg2 ;
  }
  else {
    // 期限が過ぎた場合
    msg = "オークションが終了しました";
  }

  // 作成した文字列を表示
  document.getElementById("RealtimeCountdownArea").innerHTML = msg;
}