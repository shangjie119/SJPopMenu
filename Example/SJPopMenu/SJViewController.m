//
//  SJViewController.m
//  SJPopMenu
//
//  Created by sj on 07/05/2022.
//  Copyright (c) 2022 sj. All rights reserved.
//

#import "SJViewController.h"

#import "SJChatTableViewCell.h"
#import "SJCustomSelectTextView.h"
#import "SJPopMenu.h"

@interface SJViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation SJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.dataArray[indexPath.row];
    self.textView.text = text;
    
    return [self.textView sizeThatFits:CGSizeMake(250, MAXFLOAT)].height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJChatTableViewCell"];
    cell.textView.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:SJChangePopMenuIfNeeded object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SJShowPopMenuIfNeeded object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SJShowPopMenuIfNeeded object:nil];
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SJChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJChatTableViewCell"];
    }
    return _tableView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"安康来得及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来金坷垃圣诞节卡号圣诞节暗红色的几哈四大皆空会撒娇还来得及拉可视对讲来看哈师大金坷垃圣诞节卡仕达得及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得撒旦法看了撒娇AFK领金卡设计费及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得及阿斯蒂芬；了撒开发了卡死了；方可拉伸；咖啡了；撒开发了是；开发历史啊分开了；阿萨德分开付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得及阿士大夫撒旦法看就看撒晶方科技撒会计法；撒酒疯看就是会计法快乐撒；积分开始；分开算积分；精神科拉积分开始；安静；福建省点卡；分开萨芬；了付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来金坷垃圣诞节卡号圣诞节暗红色的几哈四大皆空会撒娇还来得及拉可视对讲来看哈师大金坷垃圣诞节卡仕达得及阿斯利康的就卡死简单快捷奥施康定；几啊可视对讲喀斯柯达就卡死；的接口啦；是经典款；拉数据的卡就是打开；辣鸡萨迪克了静a拉克丝就打开了就撒肯德基卡晶方科技撒看见法卡萨就放得开撒京东方卡拉；圣诞节弗兰克；暗示法决赛了；打飞机可拉设计费雷克萨九分裤撒娇的放开了撒京东方了；及阿啥的看法了；加；两地分居安寺；登记卡洛杉矶的快乐；安静上课了敬爱的首付款；加快递费撒；的积分卡萨积分卡三六九等付款啦；撒京东方卡萨；的飞机撒开来得及付款了；按实际付款了；as京东方；来看付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方安康来金坷垃圣诞节卡号圣诞节暗红色的几哈四大皆空会撒娇还来得及拉可视对讲来看哈师大金坷垃圣诞节卡仕达得及阿斯利康的就卡死简单快捷奥施康定；几啊可视对讲喀斯柯达就卡死；的接口啦；是经典款；拉数据的卡就是打开；辣鸡萨迪克了静a拉克丝就打开了就撒肯德基卡晶方科技撒看见法卡萨就放得开撒京东方卡拉；圣诞节弗兰克；暗示法决赛了；打飞机可拉设计费雷克萨九分裤撒娇的放开了撒京东方了；及阿啥的看法了；加；两地分居安寺；登记卡洛杉矶的快乐；安静上课了敬爱的首付款；加快递费撒；的积分卡萨积分卡三六九等付款啦；撒京东方卡萨；的飞机撒开来得及付款了；按实际付款了；as京东方；来看付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方安康来金坷垃圣诞节卡号圣诞节暗红色的几哈四大皆空会撒娇还来得及拉可视对讲来看哈师大金坷垃圣诞节卡仕达得及阿斯利康的就卡死简单快捷奥施康定；几啊可视对讲喀斯柯达就卡死；的接口啦；是经典款；拉数据的卡就是打开；辣鸡萨迪克了静a拉克丝就打开了就撒肯德基卡晶方科技撒看见法卡萨就放得开撒京东方卡拉；圣诞节弗兰克；暗示法决赛了；打飞机可拉设计费雷克萨九分裤撒娇的放开了撒京东方了；及阿啥的看法了；加；两地分居安寺；登记卡洛杉矶的快乐；安静上课了敬爱的首付款；加快递费撒；的积分卡萨积分卡三六九等付款啦；撒京东方卡萨；的飞机撒开来得及付款了；按实际付款了；as京东方；来看付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来金坷垃圣诞节卡号圣诞节暗红色的几哈四大皆空会撒娇还来得及拉可视对讲来看哈师大金坷垃圣诞节卡仕达得及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得撒旦法看了撒娇AFK领金卡设计费及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得及阿斯蒂芬；了撒开发了卡死了；方可拉伸；咖啡了；撒开发了是；开发历史啊分开了；阿萨德分开付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得及阿士大夫撒旦法看就看撒晶方科技撒会计法；撒酒疯看就是会计法快乐撒；积分开始；分开算积分；精神科拉积分开始；安静；福建省点卡；分开萨芬；了付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方", @"安康来得及付款京东方萨克；京东方；卡视角的风口浪尖撒旦法困了就睡打开房间快乐撒大姐夫来看撒京东方"];
    }
    return _dataArray;
}


@end
