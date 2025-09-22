-- 0921副問い合わせについてうろ覚えで演習問題手が止まってしまったので復習
/*
◆サブクエリの置ける場所について
サブクエリの置ける場所は、「値（単数、複数リスト）」か「テーブル」が来ると文法的に期待されている場所
「単一の値」が入った箱（スカラーサブクエリ）
    比較演算子（=,<,>,<>等）の後。
    select句
「値のリスト」が入った箱（リスト）ex:('301','302','305')が返ってくる時など
    in　の後ろ in (select scode from syouhin where price >=150 );
    any/allの後ろ
*/


select * from uriage where syouhin =
  (select scode from syouhin where price >= 150);
--↑の（副問い合わせ）部分が実行されて↓になって実行される。
select * from uriage where syouhin = '301';
/*の副問い合わせの意味は、syouhinテーブルの項目priceが150と一致する行の
scodeを「1つだけ」セレクトして、そのscodeがuriage.syouhinと一致するすべての行の
データを選んで表示するという動作。複数項目返って来る可能性がある場合は「in」を使って、
↓のように書いても良い。単一行副問合せにより2つ以上の行が戻されます＝だとこのエラーになる*/
select * from uriage where syouhin in
    (select scode from syouhin where price >= 150);
/*「=」「in」「exists」それぞれの使い分け
「＝」はサブクエリに単一の値（1行1列）を期待している。ex:'301'
それなのに、*で全てのデータを渡すと完全に一致委している商品コードだけが知りたいのに多すぎるとなってしまう。
「in」はサブクエリに値のリスト（多行1列）を期待する"301","302","305"の様な。
「EXISTS」はお店の人に「サンドイッチは『ありますか？』『ありませんか？』」だけ聞いている。
返ってきたものが全ての商品だろうが、リストだろうが、単一の値だろううが、TRUEなら気にしない。
*/

--0921_Having句での副問い合わせ
select tokuisaki from uriage
    group by tokuisaki
    having min(su)<(select min(su) from uriage where tokuisaki = '501');
