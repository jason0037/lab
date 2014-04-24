# encoding: utf-8

task :data => :environment do  
  puts "Importing lab_datas"
  class BData < LabData
	 set_table_name "B000001_reading"
  end
  BData.delete_all
  BData.create([
  	{point_id:'000001',read_at:'20100101010001',saved_at:'20100101010001',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010002',saved_at:'20100101010002',value:'1.01',source:'0'},
  	{point_id:'000001',read_at:'20100101010003',saved_at:'20100101010003',value:'1.02',source:'0'},
  	{point_id:'000001',read_at:'20100101010004',saved_at:'20100101010004',value:'1.03',source:'0'},
  	{point_id:'000001',read_at:'20100101010005',saved_at:'20100101010005',value:'1.04',source:'0'},
  	{point_id:'000001',read_at:'20100101010006',saved_at:'20100101010006',value:'1.05',source:'0'},
  	{point_id:'000001',read_at:'20100101010007',saved_at:'20100101010007',value:'1.06',source:'0'},
  	{point_id:'000001',read_at:'20100101010008',saved_at:'20100101010008',value:'1.07',source:'0'},
  	{point_id:'000001',read_at:'20100101010009',saved_at:'20100101010009',value:'1.08',source:'0'},
  	{point_id:'000001',read_at:'20100101010010',saved_at:'20100101010010',value:'1.09',source:'0'},
  	{point_id:'000001',read_at:'20100101010011',saved_at:'20100101010011',value:'1.10',source:'0'},
  	{point_id:'000001',read_at:'20100101010012',saved_at:'20100101010012',value:'1.11',source:'0'},
  	{point_id:'000001',read_at:'20100101010013',saved_at:'20100101010013',value:'1.12',source:'0'},
  	{point_id:'000001',read_at:'20100101010014',saved_at:'20100101010014',value:'1.13',source:'0'},
  	{point_id:'000001',read_at:'20100101010015',saved_at:'20100101010015',value:'1.14',source:'0'},
  	{point_id:'000001',read_at:'20100101010016',saved_at:'20100101010016',value:'1.15',source:'0'},
  	{point_id:'000001',read_at:'20100101010017',saved_at:'20100101010017',value:'1.16',source:'0'},
  	{point_id:'000001',read_at:'20100101010018',saved_at:'20100101010018',value:'1.17',source:'0'},
  	{point_id:'000001',read_at:'20100101010019',saved_at:'20100101010019',value:'1.18',source:'0'},
  	{point_id:'000001',read_at:'20100101010020',saved_at:'20100101010020',value:'1.19',source:'0'},
  	{point_id:'000001',read_at:'20100101010021',saved_at:'20100101010021',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010022',saved_at:'20100101010022',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010023',saved_at:'20100101010023',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010024',saved_at:'20100101010024',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010025',saved_at:'20100101010025',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010026',saved_at:'20100101010026',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010027',saved_at:'20100101010027',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010028',saved_at:'20100101010028',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010029',saved_at:'20100101010029',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010030',saved_at:'20100101010030',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010031',saved_at:'20100101010031',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010032',saved_at:'20100101010032',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010033',saved_at:'20100101010033',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010034',saved_at:'20100101010034',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010035',saved_at:'20100101010035',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010036',saved_at:'20100101010036',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010037',saved_at:'20100101010037',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010038',saved_at:'20100101010038',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010039',saved_at:'20100101010039',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010040',saved_at:'20100101010040',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010041',saved_at:'20100101010041',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010042',saved_at:'20100101010042',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010043',saved_at:'20100101010043',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010044',saved_at:'20100101010044',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010045',saved_at:'20100101010045',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010046',saved_at:'20100101010046',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010047',saved_at:'20100101010047',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010048',saved_at:'20100101010048',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010049',saved_at:'20100101010049',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010050',saved_at:'20100101010050',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010051',saved_at:'20100101010051',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010052',saved_at:'20100101010052',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010053',saved_at:'20100101010053',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010054',saved_at:'20100101010054',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010055',saved_at:'20100101010055',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010056',saved_at:'20100101010056',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010057',saved_at:'20100101010057',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010058',saved_at:'20100101010058',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010059',saved_at:'20100101010059',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010100',saved_at:'20100101010100',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010101',saved_at:'20100101010101',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010102',saved_at:'20100101010102',value:'1.01',source:'0'},
  	{point_id:'000001',read_at:'20100101010103',saved_at:'20100101010103',value:'1.02',source:'0'},
  	{point_id:'000001',read_at:'20100101010104',saved_at:'20100101010104',value:'1.03',source:'0'},
  	{point_id:'000001',read_at:'20100101010105',saved_at:'20100101010105',value:'1.04',source:'0'},
  	{point_id:'000001',read_at:'20100101010106',saved_at:'20100101010106',value:'1.05',source:'0'},
  	{point_id:'000001',read_at:'20100101010107',saved_at:'20100101010107',value:'1.06',source:'0'},
  	{point_id:'000001',read_at:'20100101010108',saved_at:'20100101010108',value:'1.07',source:'0'},
  	{point_id:'000001',read_at:'20100101010109',saved_at:'20100101010109',value:'1.08',source:'0'},
  	{point_id:'000001',read_at:'20100101010110',saved_at:'20100101010110',value:'1.09',source:'0'},
  	{point_id:'000001',read_at:'20100101010111',saved_at:'20100101010111',value:'1.10',source:'0'},
  	{point_id:'000001',read_at:'20100101010112',saved_at:'20100101010112',value:'1.11',source:'0'},
  	{point_id:'000001',read_at:'20100101010113',saved_at:'20100101010113',value:'1.12',source:'0'},
  	{point_id:'000001',read_at:'20100101010114',saved_at:'20100101010114',value:'1.13',source:'0'},
  	{point_id:'000001',read_at:'20100101010115',saved_at:'20100101010115',value:'1.14',source:'0'},
  	{point_id:'000001',read_at:'20100101010116',saved_at:'20100101010116',value:'1.15',source:'0'},
  	{point_id:'000001',read_at:'20100101010117',saved_at:'20100101010117',value:'1.16',source:'0'},
  	{point_id:'000001',read_at:'20100101010118',saved_at:'20100101010118',value:'1.17',source:'0'},
  	{point_id:'000001',read_at:'20100101010119',saved_at:'20100101010119',value:'1.18',source:'0'},
  	{point_id:'000001',read_at:'20100101010120',saved_at:'20100101010120',value:'1.19',source:'0'},
  	{point_id:'000001',read_at:'20100101010121',saved_at:'20100101010121',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010122',saved_at:'20100101010122',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010123',saved_at:'20100101010123',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010124',saved_at:'20100101010124',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010125',saved_at:'20100101010125',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010126',saved_at:'20100101010126',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010127',saved_at:'20100101010127',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010128',saved_at:'20100101010128',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010129',saved_at:'20100101010129',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010130',saved_at:'20100101010130',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010131',saved_at:'20100101010131',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010132',saved_at:'20100101010132',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010133',saved_at:'20100101010133',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010134',saved_at:'20100101010134',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010135',saved_at:'20100101010135',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010136',saved_at:'20100101010136',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010137',saved_at:'20100101010137',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010138',saved_at:'20100101010138',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010139',saved_at:'20100101010139',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010140',saved_at:'20100101010140',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010141',saved_at:'20100101010141',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010142',saved_at:'20100101010142',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010143',saved_at:'20100101010143',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010144',saved_at:'20100101010144',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010145',saved_at:'20100101010145',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010146',saved_at:'20100101010146',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010147',saved_at:'20100101010147',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010148',saved_at:'20100101010148',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010149',saved_at:'20100101010149',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010150',saved_at:'20100101010150',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010151',saved_at:'20100101010151',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010152',saved_at:'20100101010152',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010153',saved_at:'20100101010153',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010154',saved_at:'20100101010154',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010155',saved_at:'20100101010155',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010156',saved_at:'20100101010156',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010157',saved_at:'20100101010157',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010158',saved_at:'20100101010158',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010159',saved_at:'20100101010159',value:'1.00',source:'0'},
  	{point_id:'000001',read_at:'20100101010200',saved_at:'20100101010200',value:'1.00',source:'0'}])
end