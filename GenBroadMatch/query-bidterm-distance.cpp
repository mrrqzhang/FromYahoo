#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <map>
#include <time.h>
#include <set>
#include <algorithm>
#include <iterator>


using namespace std ;

const float MinScore=0.8 ;


std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems) {
	    std::stringstream ss(s);
	    std::string item;
	    while (std::getline(ss, item, delim)) {
		elems.push_back(item);
	    }
	    return elems;
}


std::vector<std::string> split(const std::string &s, char delim) {
	    std::vector<std::string> elems;
	    split(s, delim, elems);
            return elems;
};

struct BTFeature {
       map<string, float> featuremap ;
       set<string> btnameset ;
       float squaresum ;
       BTFeature () {};
       BTFeature (map<string, float>& f, set<string> n, float s) {
	       featuremap=f ;
	       btnameset=n ;
	       squaresum=s ;
       }
} ;      

int main(int argc, char* argv[])
{
   time_t times,timee ;
   time(&times) ;
   ifstream btfile ;
   btfile.open(argv[2]) ;
   if (!btfile ) {
	std::cout << "bidterm file does not exist" << std::endl ;	
	exit(0) ;
   }
   map<string, BTFeature> btfeature ;
   while (!btfile.eof()){
      string line ;
      getline(btfile, line) ;
      vector<string> vstr = split(line, '\t') ;
      if (vstr.size()!=2) continue ;
      string bidterm = vstr[0] ;
      vector<string> feature = split(vstr[1],'|')  ;
     
      float sx=0 ;
      map<string, float> featurevalue ;
      set<string> btname ;
      for(int i=0; i<feature.size(); ++i){
	      vector<string> wordscore = split(feature[i],':') ;
	      if(wordscore.size()!=2) {cerr << "feature error: "<<feature[i] <<" " << wordscore.size() << " " << wordscore[0] << " " <<endl; continue;}
	      featurevalue[wordscore[0]]=atof(wordscore[1].c_str()) ;
	      btname.insert(wordscore[0]) ;
      	      sx+=atof(wordscore[1].c_str())*atof(wordscore[1].c_str()) ;
      }
      btfeature[bidterm]=BTFeature(featurevalue,btname, sqrt(sx)) ;   
   }
   btfile.close() ;
   ifstream queryfile ;
   queryfile.open(argv[1]) ;
   int count=0;
   while (!queryfile.eof()) {
	string line ;
	getline(queryfile, line) ;
	vector<string> vstr = split(line, '\t') ;
	if(vstr.size()!=2) {cerr << "line error: " <<line <<endl; continue;}
	string query = vstr[0] ;
	vector<string> feature = split(vstr[1],'|')  ;
	float sy=0 ;
	map<string, float> queryfeature ;
	set<string> querynameset ;
	for(int i=0; i<feature.size(); ++i){
		vector<string> wordscore = split(feature[i],':') ;
		if(wordscore.size()!=2)
			{cerr << "feature error: "<<feature[i] <<endl; continue;}
		queryfeature[wordscore[0]] = atof(wordscore[1].c_str()) ;
		querynameset.insert(wordscore[0]) ;
		sy+=atof(wordscore[1].c_str())*atof(wordscore[1].c_str()) ;
	}
	sy = sqrt(sy) ;
	map<string, BTFeature>::iterator iter ;

        for(iter=btfeature.begin(); iter!=btfeature.end(); ++iter) {
		string bidterm = iter->first ;
		BTFeature& btmap = iter->second ;
		float sx = btmap.squaresum ;
		map<string,float>& features = btmap.featuremap ;
		set<string>& btset = btmap.btnameset ;

		double sxy=0 ;
		set<string> intersect ;
		std::set_intersection(querynameset.begin(), querynameset.end(), btset.begin(), btset.end(), std::inserter(intersect, intersect.end()));
		for(set<string>::iterator iter=intersect.begin(); iter!=intersect.end(); ++iter){
			sxy += features[*iter]*queryfeature[*iter];  //qiter->second*iter->second ;
		}

		float score = sxy/sx/sy ;
		if(score>=MinScore) 
			cout << query << "\t" << bidterm << "\t" << score << endl ;

	}
	count++ ;
	if (count%1000==0){ cerr<< "Processing: " << count << endl ;}
   }
   queryfile.close();
   time(&timee) ;
   cerr << "time used: " << difftime(timee,times) << "seconds" << endl ;
}



