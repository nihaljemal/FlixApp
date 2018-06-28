//
//  MoviesViewController.m
//  FlixApp
//
//  Created by Nihal Riyadh Jemal on 6/27/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "MoviesViewController.h"
#import "movieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.activityIndicator startAnimating];
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    
}

- (void)fetchMovies{
    
    //-additional Initial network requirement checking
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your wifi aint wi-fly"
    preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *tryAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel
    handler:^(UIAlertAction * _Nonnull action) {
    // handle cancel response here. Doing nothing will dismiss the view.
        //[self.refreshControl endRefreshing];
        [self fetchMovies];
    
    }];
    // add the cancel action to the alertController
    [alert addAction:tryAction];
    // create an OK action
    
    

    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            // possibly remove later NSLog(@"%@", [error localizedDescription]);
            
        //-additional code for what happens after the alert controller has finished presenting
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dataDictionary);
            // TODO: Get the array of movies
            self.movies = dataDictionary[@"results"];
            for (NSDictionary *movie in self.movies){
                NSLog(@"%@", movie[@"title"]);
            }
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            [self.tableView reloadData];
            
            [self.activityIndicator stopAnimating];

        }
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    movieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.SynopsisLabel.text = movie[@"overview"];
    //cell.textLabel.text = movie[@"title"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterLabel.image = nil;
    [cell.posterLabel setImageWithURL:posterURL];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailViewCOntroller = [segue destinationViewController];
    detailViewCOntroller.movie = movie;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Tapping on a movie!");
}


@end
