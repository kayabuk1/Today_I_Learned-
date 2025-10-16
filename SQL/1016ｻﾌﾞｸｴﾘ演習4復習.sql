//1016演習4復習
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
-- ⑴商品A菓子の販売実績、商品名、得意先名、販売日付、売上数を表示
(得意先ﾃｰﾌﾞﾙと商品ﾃｰﾌﾞﾙは結合するのはNG)
select
  (select s4.name from syouhin4 s4 where s4.sno = m4.sno)as 商品名,
  (select t4.name from tokuisaki4 t4 where t4.tno =
    (select h4.tno from hanbai4 h4 where h4.hno = m4.hno))as 得意先名,
  (select h4.day from hanbai4 h4 where h4.hno = m4.hno)as 販売日付,
  m4.su as 売上数
from meisai4 m4 where m4.sno = 
    (select s4.sno from syouhin4 s4 where s4.name = 'A菓子')
;

## SQL 復習問題 (全10問)
テーブル定義:
SYOUHIN4: SNO (商品番号), NAME (商品名), TANKA (単価)
TOKUISAKI4: TNO (得意先番号), NAME (得意先名), ADR (住所)
HANBAI4: HNO (販売番号), DAY (売上日), TNO (得意先番号)
MEISAI4: MNO (明細番号), HNO (販売番号), SNO (商品番号), SU (売上数量)
【基礎：SELECTとWHERE】
問1: syouhin4テーブルから、単価（TANKA）が
100円以上の商品名（NAME）を全て表示してください。
select s4.name as 商品名
from syouhin4 s4
where s4.tanka >= 100;
問2: tokuisaki4テーブルから、住所（ADR）に
  「千葉」という文字が含まれる得意先名（NAME）を全て表示してください。
select t4.name as 得意先名
from tokuisaki4 t4
where t4.adr = '千葉';
select t4.name as 得意先名
from tokuisaki4 t4
where t4.adr LIKE '%千葉%';

【集計とグループ化：GROUP BYとHAVING】
問3: meisai4テーブルの販売番号（HNO）ごとに、売上数量（SU）の合計を計算し、
  販売番号と売上数量の合計を表示してください。
select 
from hanbai4 h4
group by h4.su
;

問4: 問3の結果から、さらに売上数量の合計が10以上の販売番号だけを表示してください。

【テーブル結合：JOIN】

問5: hanbai4テーブルとtokuisaki4テーブルを結合し、各販売記録について、販売番号（HNO）、売上日（DAY）、得意先名（NAME）を一覧で表示してください。

問6: 4つのテーブルを全て結合し、2025年9月1日以降の売上について、販売日、得意先名、商品名、売上額（SU * TANKA）を計算して表示してください。

【サブクエリ】

問7: syouhin4テーブルの中で、最も単価が高い商品の商品名と単価を表示してください。（サブクエリを使用すること）

問8: hanbai4テーブルに記録がある（=一度でも取引があった）得意先の、得意先番号（TNO）と得意先名（NAME）をtokuisaki4テーブルから表示してください。（EXISTSを使用すること）

問9: 全商品の平均単価よりも単価が高い商品の、商品名と単価をsyouhin4テーブルから表示してください。（サブクエリを使用すること）

問10 (高難易度): syouhin4テーブルの各商品について、商品名と、その商品の「総売上数量ランキング」を単価の高い順に表示してください。（ROWNUMまたはウィンドウ関数RANK()/ROW_NUMBER()を使用すること）
