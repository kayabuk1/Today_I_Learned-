-- 0921副問い合わせについてうろ覚えで演習問題手が止まってしまったので復習
-- 0927追記
-- 0929追記
-- 0930追記
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
-- 0927ここから
-- 8.1副問い合わせの結果が「一つ」になる場合
select * from uriage where syouhin =
    (select scode from syouhin where price =150);
/*訳：「syouhinテーブルの、price列が150の行のscode」と「uriageテーブルのsyouhin列の値が等しい行を全て」
結果セット(Result Set)で取り出す。*/
-- 8.2副問い合わせの結果が「複数になる『可能性がある』場合」
select * from uriage where syouhin IN
    (select scode from syouhin where price >=150);
/*訳：「syouhinテーブルのprice列の値が150以上の行(データ)のscode『リストのどれかの値と』」と
「uriageﾃｰﾌﾞﾙのsyouhin列の値が等しい行(ﾃﾞｰﾀ)を全て」結果セットとして取り出す。*/

-- 8.2 Having句での副問い合わせ
select tokuisaki from uriage group by tokuisaki having min(su) <
    (select min(su) from uriage where tokuisaki = '501');
/*「uriageﾃｰﾌﾞﾙを列tokuisakiでグループ化。次にそのグループに対して以下の条件(having~)で絞込みを行う。」
グループのsuの最小値。それが、「uriageﾃｰﾌﾞﾙの列tokuisaki'501'のsuの最小値」
より小さいグループのtokuisakiを表示する。
group by と来たら、その後は、～の行ではなく、～のグループという主語で文章が推移していくと考える。
処理フローの優先順位は、サブクエリ⇒グループ化⇒having句での比較。
havingと言うグループ化後にグループの絞り込みを行う句の中での、比較演算子の後に（）サブクエリが
置かれているので、一行一列の値が返されることが期待されている。
（サブクエリ）の中で集計関数が使えるのはwhere tokuisaki ='501'で対象データを'501'があるものだけと、
絞り込んでいるから。集計関数はgroup by が無くてもwhere句で対象が絞り込めていれば使える。
*/

-- 8.4その他の場所での副問い合わせ
select tokuisaki,round(avg(su)),round((select avg(su) from uriage))
from uriage group by tokuisaki;
/*訳：uriageのsuの全体平均も四捨五入したものと、
uriageテーブルをtokuisakiでグループ化した、各グループ名、各グループのsuの平均を四捨五入したものを、
結果セットとして出力する。(①得意先ごとの平均、②全体の平均を比較したい)
サブクエリをselect句で使う時とhaving句やwhere句で使う時の使い分けは何を基準にどの様に？
⇒「サブクエリが計算した結果を、どう使いたいか？（目的は？）」
１．whereやhavingで使うとき⇒目的：絞り込みの条件として使いたい(ﾒｲﾝの問い合わせ結果の比較相手として)。
２．select句で使うとき⇒目的：結果に「追加情報」として表示したい。単純にメインの出力の隣に並べる。
３．from⇒問い合わせの元となる一時的なテーブルを作るために使う。
*/
-- 8.4.2from句でのサブクエリ
select round(max(avg_table.avg_su),1) as max_avg
from (select avg(su) as avg_su from uriage group by tokuisaki) avg_table;
/*訳：（uriage表をtokuisakiでグループ化する。そしてその各グループのsuの平均を結果セットとして出力）
そして（サブクエリ結果セット）をavg_tableとして扱う。
そしてavg_tableから、su平均の最大グループのsu平均を最大平均として、出力する。
from句は「得意先ごとの平均売上数」のリスト、つまりavg_suという名前の一時的な列を作成する。
select句はそのavg_suという列の中から最大値を見つけたい。
round()はround(四捨五入したい値,小数点以下何桁まで表示するか)との様に2つの引数を渡すことが出来る。
小数点以下桁を指定しない場合は整数に丸められる。
*/

-- 8.5 ROWNUM列と副問い合わせ
select t1.no, t1.syouhin,t1.su, rownum t1_rownum
from uriage t1 order by t1.su;
/*訳：fromどのテーブルから⇒rownumの採番⇒select(何を表示するか)⇒order byソートの順で処理される。
uriageテーブルをt1と言うエイリアスで扱います。
そしてそのt1テーブルからrownum列、su列、syouhin列、no列を結果セットとして、suの昇順で表示します。
    
「ROWNUM」とは？なぜt1.rownumではないのか
rownum列はuriageテーブルに元々存在しない列。疑似列と呼ばれる特殊な列。
from uriageの命令を受けてデータを取り出す際に、取り出した順番で番号を振ったもの。
Orcleのデータ取り出し作業記録の様なもの。
なので、rownumはuriageテーブルに属しておらず、一時的な列なのでt1.rownumと書かない。
*/

--8.5.2難しい……
select t3.no, t3.syouhin, t3.su, t3.t1_rownum, rownum t3.t2_rownum
    from(select t2.no, t2.syouhin, t2.su, t2.t1_rownum, rownum t2_rownum
        from(select t1.no, t1.syouhin, t1.su, rownum t1_rownum 
            from uriage t1 order by t1.su)  t2 ) t3
where t3.t2_rownum >= 3 and t3.t2_rownum <= 5;
/*
１．内側（）uriage表はt1とい名前で扱うよ。そしてt1表からno,syouhin,suの列と取り出すときにrownum列も付けて
その後suで昇順にして表示するよ。この時取り出した順のrownum列もぐちゃぐちゃになるよ。
2．外側（）内側（）で表示された表をt2という名前で扱うよ。そしてt2表から、またno,syouhin,suとt2表を作るときに
振ったt1_romnumの列を取り出すよ。
そんでその取り出すときに、取り出した順番を振ったt2_rownumという列もくっつけて、表示するよ。
orderしてないからt2_rownumは取り出した順できれいに並んでいるよ。
3．外側サブクエリでの表示結果をt3って言う別名で扱うよ。
そしてその表t3から、whereでt2_rownum列の値が3以上かつ、5以下の行（データ）に絞り込んで、
no,syouhin,su,t1_rownum,t2_rownum列を表示するよ。

こういった複雑な書き方の目的は、「ランキングの途中から、特定の範囲だけを取り出す」為とのこと。
いわゆるページネーション（掲示板の「3ページ目を表示」のような機能を）実現するため。

なぜ単純に書けないのか？
ROWNUMの「厄介な制約」の為。
ROWNUMは実は、where rownum > 1の様な条件に使っても、1行も結果を返さない。
なぜなら、ROWNUMは「selectで結果セットに含まれることが確定した行」に1,2,3,...と
結果セットを作る為に取り出した順で振られる。
なので、例えばwhereでrownum＞=３とすると、取り出すことが確定した途端にrownumが１となってしまい、
whereのrownum列の値が３以上という条件を満たさなくなってしまう。
なので1行も結果として出力されなくなってしまう。
なので内側のクエリで、その場でしか使えないt2_rownumというシール（order by t1.suでsuの昇順が記録された
t2_rownum）をt3というテーブルの中のt2_rownumという本物の列として扱わせてしまう。
一度ROWNUMが本物の列として扱われるテーブルを作ってしまえば、あとはメインクエリで自由な条件で絞り込める。
*/

-- 8.6相関副問い合わせ
select * from tokuisaki where EXISTS
    (select * from uriage where uriage.tokuisaki = tokuisaki.tcode);
訳：✖uriageテーブルから、uriage表のtokuisaki列のデータと,tokuisaki表のtcode列のデータが同じ行のものが、
tokuisakiテーブルに「存在していたら」、その存在しているデータ全てを結果セットとして出力する。→間違い。

そもそもこのSQL文の目的は、「一度でも取引(売上)があって得意先を、得意先テーブルから全て表示する」になる。
EXISTSを使った相関副問い合わせは、通常の副問い合わせとは異なり、外側(メインクエリ)から内側(サブクエリ)へ、
「一行ずつ」問い合わせながら実行される。
１．先ずメインクエリの「select * from tokuisaki」が処理され、
    tokusiakiテーブルから具体的な値の入った1行が取り出される。（例えば、tcodeが'501',tnameが'春菓子店'）
２．次にサブクエリに、取り出した行の必要な値を渡す('501')。
    そしてサブクエリが「where uriage.tokuisaki = '501'」という形になって実行される。
３．そしてEXISTSで存在が真か偽か判定する。
    （uriageテーブルに得意先コード'501'の売上(記録)があるかチェックする）
    真なら最終的な結果セットに加える。
４．次の行へ
    tokuisakiテーブルの全ての行に対して、この1～4のチェックを繰り返す。

・なぜ通常のサブクエリと処理のしかたが異なるのか？
通常のサブクエリは非相関サブクエリとも言える。
つまりサブクエリが単独で完結していて、（）の中のSQL文は、外側とは無関係に実行できる。
通常サブクエリ例:...from uriage where syouhin in (select scode from syouhin where price >= 150)
今回のはサブクエリが外側のクエリに依存している為、外側のクエリの行ごとに繰り返し実行される。
select * from tokuisaki where EXISTS 
    (select * from uriage where uriage.tokuisaki = tokuisaki.tcode);
tokuisaki.tcodeは外側のクエリ(tokuisakiﾃｰﾌﾞﾙ)の列。なのでこのサブクエリは外側のクエリからtcodeの値を
貰わないと、単独では実行出来ない「不完全なSQL文」。この内外の依存関係（＝相関）がある為、データベースは
仕方なく、「内側のサブクエリを実行したいけれど、外のクエリのテーブル列名が指定されているから、
ここままでは実行できない。なのでまず外側から一行(例えば'501')取って来て、その値を内側に渡して内側を実行する。
終わったら、また外側の次の行を取って来て……」と言う繰り返し処理を行わざるを得なくなっている。
「EXISTS」はこの「ループしながら条件に合致する行(データ)が存在するかチェックする」という処理に合わせて
最適化された便利なキーワード。つまり先に相関関係によるループがあって、後からそれによる処理をEXISTSと言う
単語に任せることにした。そんなイメージ。
whereで条件が来ると、例えば>=150なら全データが150以上か、ざっと150と言う一つの値と見比べれば良いけれど、
=tokuisaki.tocodeとされてしまうと、tcodeの値は複数あるので、条件に合致するか照合作業の際にtcodeの具体的な
値を毎回取ってきてから照合して、と言う繰り返しの処理にならざるを得ない。静的な値と動的な値による動作の差。

-- 0928ここから
-- 8.7　ANYとALL ANYは「OR条件」、ALLは「AND条件」
select tokuisaki, udate from uriage where udate = ANY
    (select udate from uriage where tokuisaki = 500);
訳：売上テーブルから、得意先列が500の行の売上日列データのリストを作る。そして、
その売上日リストのいづれかの値に売上日が等しい得意先名と売上日を売上テーブルから結果セットして表示する。
⇒つまり目的は、得意先コード500の売上日と同じ売上日の得意先名を見たい。
-- 8.7.2そしてこの「= ANY」は「IN」と同じ働きをする。
select tokuisaki, udate from uriage where udate IN
   (select udate from uriage where tokuisaki = 500);
--8.7.3しかしANYなら「＞ANY」や「<=ANY」などIN演算子ではできなかった条件を設定出来る。
select no, tokuisaki, su from uriage where su < ANY
    (select su from uriage where tokuisaki = 501);
訳：売上テーブルから得意先列値が501のデータ(行)の売上数列値の結果セットリストを作る。
    そして、その売上数結果セットリストの値のどれか一つでも下回る、つまり
    結果セットの最大数より小さい売上数の列データを持つ行を売上テーブルから
    伝票番号、得意先名、売上数の列を結果セットとして出力する。
目的：得意先501の「最大の」売上数より小さい売上数だった取引の記録を見たい。
    
-- 8.7.4 ALL演算子
select no, tokuisaki, su from uriage where su < ALL
    (select su from uriage where tokuisaki = 501);
訳：売上テーブルから得意先列コード501の売り上げ数列データリストを結果セットとして取り出し、
    そしてそのリストの売り上げ数の値を「全て下回った」売り上げ数列データを持つ、伝票番号、得意先名、
    売り上げ数を結果セットとして出力する。
目的：得意先501の「最小の」売上数より小さい売上数だった取引の記録を見たい。
