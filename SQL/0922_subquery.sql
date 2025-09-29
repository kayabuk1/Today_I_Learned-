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

-- 演習問題４
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所

-- ⑴商品A菓子の販売実績、商品名、得意先名、販売日付、売上数を表示(得意先ﾃｰﾌﾞﾙと商品ﾃｰﾌﾞﾙは結合するのはNG)
select syouhin4.name, tokuisaki4.name, hanbai4.day, meisai4.su
from(select * from
    (select * from 
    (select * from habai4 where hanabai4.tno = tokuisaki4.tno)
    where hanabai4.no = meisai4.hno )
    where syouhin4.sno = meisai4.sno)
where syouhi4.name ='A菓子'
order by day desc;⇒間違い
複数テーブルに欲しい列が渡っている。テーブルを作るときはfrom句でサブクエリを使うのだったかな？
4テーブルにわたっているものを一つのテーブルとして返す必要があるな。そうすると入れ子の入れ子のサブクエリ
にしないとかな。みたいな思考だった。

「from句のサブクエリ」
目的：問い合わせの土台となる、新しいﾃﾞｰﾀｿｰｽ(ﾃｰﾌﾞﾙ)を作りたい時。
例：グループ化して売上平均を出して、売上平均のテーブルを作って、それを問い合わせの土台とする。
    ただしfrom句のサブクエリは外側のテーブルを参照することは出来ない。あくまで自己を元にする。
「select句/where句のサブクエリ」
目的：あるテーブルを処理している最中に、各行に関連する「追加情報」を項目が外部キーで関連付けられている
別のテーブルから取ってくるとき。
「EXISTS以外での相関サブクエリ」
相関サブクエリは関係はあるが異なるテーブルの行と行を関連づけるテクニックなので、他の場所でも普通に使う。
1行ずつ何かをしたい時は相関サブクエリが有効。
    
meisai4.su売上数、hanabai4.day販売日付、syouhin4.name商品名、tokuisaki4.name得意先名が
それぞれ別のテーブルに存在する。⇒meisai4を主役テーブルにして、足りない情報を各テーブルから取って来て
表示するという考えで組み立てる。
    そも主役テーブルを何にするかはどう決めるのか？
    ⇒原則「最も詳細な情報、つまり『一番粒度が細かい』テーブルを主役にする」
    tokuisaki4：顧客情報（顧客1人につき1行）
    syouhin4：商品マスタ（商品1つにつき1行）
    hanabai4：販売記録（1回の取引につき1行）
    meisai4：販売明細（1回の取引の中の、商品1つにつき1行）
    一番細かい情報を持っているテーブルを主役にすると、他との情報が「1対多」で整理出来るので書きやすい。
１．まず主役のmeisai4ﾃｰﾌﾞﾙから売上数を取得する。
select su from meisai4;
２．select句のサブクエリで関連情報を一行ずつ取ってくる。
select
    (select name from syouhin4 where syouhin4.sno = meisai4.sno) as "商品名",
    (select name from tokuisaki4 where tokuisaki4.tno =
        (select tno from hanbai4 where hanbai4.hno = meisai4.hno))as "得意先名",
    (select day from hanabai4 where hanbai4.hno = meisai4.hno) as "販売日付",
    su as "売上数"
from meisai4 
３．最後にwhere句で条件を絞り込み、order byで並び替え。
where (select name from syouhin4 where syouhin4.sno =meisai4.sno) = 'A菓子'
order by day desc;
訳：明細表から、
    商品表の商品番号と明細表の商品番号が同じ行の商品表の商品名が'A菓子'の列という条件で、
    商品表の商品番号と明細表の商品番号が同じ行の商品表の商品名を取ってくる。
    販売記録表の販売番号と明細表の販売番号が同じ行の販売表の得意先番号を取ってきて、
    得意先表の得意先番号と同じ行の得意先名を取ってくる。
    販売記録表の販売番号と明細表の販売番号が同じ行の販売記録表の日付を取ってくる。
    明細表の売上数を取ってくる。
※もしJOINを使って良いなら……
SELECT
    s.name AS "商品名",
    t.name AS "得意先名",
    h.day  AS "販売日付",
    m.su   AS "売上数"
FROM
    meisai4 m
    INNER JOIN hanbai4 h      ON m.hno = h.hno
    INNER JOIN syouhin4 s     ON m.sno = s.sno
    INNER JOIN tokuisaki4 t   ON h.tno = t.tno
WHERE
    s.name = 'A菓子'
ORDER BY
    h.day DESC;
複数のテーブルを組み合わせたい時はJOINを使う方が圧倒的に楽。

-- ⑵最新の船橋商会の売上日の販売実績
-- 得意先、販売番号、売上日、商品名、単価、売上額（販売番号、商品番号の昇順で表示）を表示せよ。
-- 自力チャレンジ
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
欲しい情報↓
得意先　tokuisaki4.name
販売番号  hanbai4.hno,meisai4.hno
売上日    hanbai4.day
単価      shouhin4.tanka
売上額    meisai4.su*shouhin4.tanka
⑴と同様にmeisai4ﾃｰﾌﾞﾙを主役テーブルにする。複数相関関係あるテーブルからデータが欲しいのでselect句でサブクエリ。
select
    (select tokuisaki4.name from tokuisaki4 where tokuisaki4.tno = 
        (select hanbai4.tno from hanbai4 where hanbai4.hno = meisai4.hno)) as '得意先',
    meisai4.hno as '販売番号',
    (select hanbai4.day from hanbai4 where hanbai4.hno = meisai4.hno) as '売上日',
    (select shouhin4.tanka from syouhin4 where syouhin4.sno = meisai4.sno) as '単価',
    meisai4.su* (select syouhin4.tanka from syouhin4 where syouhin4.sno = meisai4.sno) as '売上額'
from meisai4
where (select tokuisaki4.name from tokuisaki4 where tokuisaki4.tno = 
        (select hanbai4.tno from hanbai4 where hanbai4.hno = meisai4.hno)) = '船橋商店'    
AND (select day from hanbai4 where hno = meisai4.hno) = 
        (select MAX(day) from hanbai4 h4 INNER JOIN tokuisaki4 t4 on h4.tno = t4.tno where t4.name ='船橋商店')
order  by meisai4.hno,meisai4.sno asc;
where句の最新の日付という条件が書けなかった。

-- ⑶１回も売れていない商品名
-- 自力チャレンジ
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
欲しい情報↓
商品名　shyouhin4,name
条件なのでwhere句でサブクエリを実行する。条件を考える。
where 販売番号 is NULL?
select syouhi4.name from syouhin4 
where (meisai4.hno from meisai4 where meisai4.sno = syouhin4.sno) is NULL;
→間違い。サブクエリは結果が見つからない場合NULL値を返すのではなく「０行の結果セット(空の表)」を返す。これはNULLではない。
「EXISTS」はサブクエリが1行でも返せばTRUE。
「NOT EXISTS」はサブクエリが1行も返さなければTRUE。今回はNOT EXISTSを使う。
select name from syouhin4 where NOT EXISTS
    (select 1 from meisai4 where meisai4.sno = syouhin4.sno);
別解：NOT INを使う方法(ただしINのリストにNULLが含まれると判別不能で返ってくる行が何もなくなってしまう)
select name from syouhin4 where sno NOT IN
    (select distinct sno from meisai4);売れたことのある商品リストに含まれていない、という書き方
別解：COUNT関数を使う。countなら数値を返すので０と比較演算子＝で結ぶことが出来る。
select name from syouhin4 
    where (select count(*) from meisai4 where meisai4.sno = syouhin.sno) = 0;

-- ⑷商品の単価が高い順に3個表示する。商品名、単価、順位を表示すること。
-- 自力チャレンジ
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
欲しい情報↓
商品名　syouhin4.name as '商品名'
単価    syouhin4.tanka as '単価'
順位    order by syouhin4.tanka desc実行後にrownumを振る必要がある。
        そしてrownumは仮の列なので、正規の列として扱う為に、外側のサブクエリで内側サブクエリrownumを扱う必要がある。
select syouhin4.name as '商品名, 't2.t1.syouhin4.tanka as'単価', t2.s42_rownum as '順位' from
    (select t1.syouhin4.tanka t1.s41_rownum, rownum s42_rownum from
    （select syouhin4.tanka, rownum s41_rownum　from syouhin4 order by syouhin4.tanka desc)as t1)as t2)
where t2.s42_rownum >= 3 order by t2.s42_rownum desc;→✖考え方は〇
解答
１．基礎となる一番内側で商品を単価順に並べる。
select name, tanka from syouhin4 order by tanka DESC
２．並べ替えた結果に、ROWNUMで順位を付ける
select t1.name,t1.tanka, ROWNUM AS "順位" from
    (select name, tanka from syouhin4 order by tanka DESC) t1
３．順位が３位以内のものを絞り込む
select t2.name, t2.tanak, t2."順位" from
    (select t1.name, t1.tanka, rownum as "順位" from
        (select name, tanka, from syouhin4 order by tanka DESC
    ) t1) t2
where　t2."順位" <= 3;

別解：ウインドウ関数を使う場合
SELECT name, tanka,"順位"
FROM(SELECT name, tanka,
            -- tankaの降順で順位を付ける、という宣言
            RANK() OVER (ORDER BY tanka DESC) AS "順位"
        FROM syouhin4)
WHERE "順位" <= 3;

-- ⑸売上合計額が船橋商会よりも低く、鎌ヶ谷商会よりも高い得意先売上情報を表示　得意先番号、得意先、売上合計金額を表示
-- 自力チャレンジ
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
売上合計額が知りたい→group by だな。そこで条件で絞り込むからhaving句でサブクエリを使う？
あと自己テーブルのみで完結できる場合は？from句でサブクエリを使うとインラインビューを作って使えるのだっけな。
欲しい情報↓
得意先番号　tokuisaki4.tno
得意先     tokuisaki4.name
売上合計金額 sum(meisai4.su * syouhin4.tanka)
明細表と商品表の情報も必要だからselect句でもサブクエリ使う？いやfrom句でグループ化した表を参照出来れば問題ないはず。
売上合計を出すのに明細表と商品表も必要だから、結局明細表主役にした方がよいのかな。
select　
    from (select 
            from tokuisaki4 t4
            group by t4.tno )
where sum() < 
    select 
    (select syouhin4.tanka*(select meisai4.su from meisai4 where 
        ((select meisai4.sno from meisai4 where meisai4.hno = (
    select hanabi4.hno from hanbai4 where hanbai4.tno = tokuisaki.tno) = syouhin4.sno) 
    from syouhi4 where shouhin4.sno = (select meisai4.sno from meisai4 where meisai4.hno = (
    select hanabi4.hno from hanbai4 where hanbai4.tno = tokuisaki.tno))
    
-- 0930ここから
/*
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
*/
--⑴A菓子の販売実績(結合は不使用)。商品名、得意先名、販売日付、売上数を表示
/*
考え。まず結果セットに欲しいデータを考える。
商品名……syouhin4.name、得意先名……tokuisaki4.name、販売日付……hanbai4.day、売上数……meisai4.su
→すべて別のテーブルから取得する必要がある。from句に内部結合で置くことは禁止されている。
→どれかのテーブルを主役にして、他のテーブルをサブに。→一番データが詳細なmeisai4を主役にする。
→なぜなら明細1つごとに、販売記録1つ、商品ごとの売上数記録。主キーに対して従属するデータ種類と数が多い。
それを踏まえると骨格は、select m4.su as 売上数 from meisai4 m4 where m4.sno = h4.sno;これに継ぎ足していく。
*/
select 
    (select name from syouhin4 s4 where sno = m4.sno)as 商品名,
    (select name from tokuisaki4 t4 where tno = (select tno from hanbai4 where hno = m4.hno))as 得意先名,
    (select day from hanbai4  h4 where hno = m4.hno)as 販売日付,
    su as 売上数
from meisai4 m4 
where (select name from syouhin4 where sno = m4.sno) = 'A菓子'
;
/*
where句のルール
where [式１][比較演算子][式２]：[式1][式2]には列名、固定値、計算式、様々なものを置ける。
例1（一般的な使い方）：where [列名] 比較演算子[値orサブクエリ]
                    where price     >     100
                    where tanka     >     (select AVG(tanka)from syouhin4)
例2（応用的な使い方）：where [ｻﾌﾞｸｴﾘ1] 比較演算子 [ｻﾌﾞｸｴﾘ2]※どちらも1行1列の単一の値を返す場合のみ。両側が1対1の関係
                    where (select min(tanka)from syouhin4 where name = 'A菓子')
                    > (select max(tanka)from syouhin4 where name = 'C菓子')
*/
--⑵



































































