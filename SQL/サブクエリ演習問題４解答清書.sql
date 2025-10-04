--　1004ごちゃごちゃしてしまったので、こちらに見ないで書くチャレンジしつつ、解答書き直し
- 演習問題４
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所

-- ⑴商品A菓子の販売実績、商品名、得意先名、販売日付、売上数を表示(得意先ﾃｰﾌﾞﾙと商品ﾃｰﾌﾞﾙは結合するのはNG)
select 
  (select name from syouhin4 s4 where s4.sno = m4.sno) as　商品名,
  (select tno from tokuisaki4 t4 where t4.tno = (select tno from hanbai4 h4 where h4.hno = m4.hno )) as 得意先名,
  (select day from hanbai4 h4 where h4.hno = m4.hno)as 販売日付,
  su from meisai4 m4 
where (select name from syouhin4 s4 where s4.sno = m4.sno) = 'A菓子'
; 
-- ⑵最新の船橋商会の売上日の販売実績
-- 得意先、販売番号、売上日、商品名、単価、売上額（販売番号、商品番号の昇順で表示）を表示せよ。
select
  (select name from tokuisaki4 t4 where t4.tno = (select tno from hanbai4 h4 where h4.hno = m4.hno))as 得意先名,
  hno as 販売番号,
  (select day as 売上日 from hanbai4 h4 where h4.hno = m4.hno),
  (select name from syouhin4 s4 where s4.sno = m4.sno)as 商品名,
  (select tanka from syouhin4 s4 where s4.sno = m4.sno)as 単価,
  m4.su * (select tanka from syouhin4 s4 where s4.sno = m4.sno)as 売上額
from meisai4 m4
where
  (select name from tokuisaki4 t4 where t4.tno = (select tno from hanbai4 h4 where h4.hno = m4.hno )) 
  = '船橋商会'
AND (select day from hanbai4 h4 where h4.hno = m4.hno)
  = (select max(day) from hanbai4 h4 where h4.tno IN
       (select tno from tokuisaki4 where name = '船橋商会'))
order by 販売番号, m4.sno ASC; 
/*
サブクエリ内のASの位置
SELECT句の中でサブクエリを使う場合、別名（AS）はサブクエリの括弧の外に置く必要があります。
誤: (select day as 売上日 from ...)
正: (select day from ...) as "売上日"
サブクエリが複数の列を返している（最重要エラー）
SELECT句で列として使うサブクエリ（スカラーサブクエリ）は、必ず1行1列の結果しか返せません。
誤: (select name as 商品名, tanka as 単価 from ...)
このサブクエリはnameとtankaの2列を返そうとしているため、エラーになります。「商品名」と「単価」は、それぞれ別のサブクエリで取得する必要があります。
SUM()とGROUP BYの欠如
sum(su * s4.tanka)のように集計関数を使う場合、SELECT句に他の列（得意先名など）があると、通常はGROUP BY句が必要です。しかし、今回のサブクエリだらけの構成では、SUMの計算方法そのものが複雑になり、この形では実現できません。
*/
-- ⑶１回も売れていない商品名
select name from syouhin4 s4 
  where NOT EXISTS (select 1 from meisai4 m4 where m4.sno = s4.sno);

-- ⑷商品の単価が高い順に3個表示する。商品名、単価、順位を表示すること。
select name, tanka, 順位
from (select　name, tanka, rownum as 順位 from (select name, tanka　from syouhin4 s4 order by tanka DESC)　s41) s42
where 順位 <= 3
;
-- ⑸売上合計額が船橋商会よりも低く、鎌ヶ谷商会よりも高い得意先売上情報を表示　得意先番号、得意先、売上合計金額を表示
select t4.tno as 得意先番号, t4.name as　得意先名, 
  (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno))from meisai4 m4 
    where m4.hno IN (select h4.hno from hanbai4 h4 where h4.tno = t4.tno))as 売上合計金額
from tokuisaki4 t4
where
    (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno))from meisai4 m4 
    where m4.hno IN (select h4.hno from hanbai4 h4 where h4.tno = t4.tno))
  < (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno))from meisai4 m4 
      where m4.hno IN (select h4.hno from hanbai4 h4 where h4.tno =(select tno from tokuisaki4 where name = '船橋商会')))
AND (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno))from meisai4 m4 
      where m4.hno IN (select h4.hno from hanbai4 h4 where h4.tno = t4.tno))
  >(select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno))from meisai4 m4 
      where m4.hno IN (select h4.hno from hanbai4 h4 where h4.tno =(select tno from tokuisaki4 where name = '鎌ヶ谷商会')))
;

--⑹千葉商会への売上について、商品ごとの売り上げ合計数が習志野・鎌ヶ谷商会の売上合計数を超えた商品
select 
  (select t4.name from tokuisaki4 t4 where t4.tno = (select h4.tno from hanbai4 h4 where h4.hno = (select m4.hno from meisai4 m4 where m4.sno = s4.sno)))as 得意先名,
  s4.sno as 商品番号, s4.name as 商品名, 
  (select sum(m4.su) from meisai4 m4 where m4.sno = s4.sno))as 売上合計数
from syouhin4 s4 
where (select sum(m4.su) from meisai4 m4 where m4.sno = s4.sno)) > ANY
       (select sum(m4.su) from meisai4 m4 where m4.sno = 
          (select s4.sno from syouhin4 s4 where 
            (s4.sno = 
              (select m4.sno from meisai4 m4 where m4.hno = 
                (select h4.hno from hanbai4 where h4.tno = 
                  (select t4.tno from tokuisaki4 t4 where t4.name = '習志野商会' OR '鎌ヶ谷商会' 
                  )
                )
              )
            )
          )
        )
  ;


















