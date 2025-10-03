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



































































