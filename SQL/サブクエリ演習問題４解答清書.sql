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
-- 自力チャレンジ
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
select
  (select name from tokuisaki4 t4 where t4.tno = (select tno from hanbai4 h4 where h4.hno = m4.hno))as 得意先名,
  select hno as 販売番号,
  (select day as 売上日 from hanbai4 h4 where h4.hno = m4.hno),
  (select name as 商品名,tanka as 単価 from syouhin4 s4 where s4.sno = m4.sno),
from meisai4 m4
where (select name from tokuisaki4 t4 where t4.tno = (select tno from hanbai4 h4 where h4.hno = m4.hno ) = '船橋商会'
order by m4.hno and s4.sno ASC; 
















