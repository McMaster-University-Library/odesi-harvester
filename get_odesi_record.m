URL = 'https://search1.odesi.ca/#/details?uri=%2Fodesi%2Fcipo-598-E-1993-04.xml';
str = urlread(URL);

options = weboptions;
options.Timeout = 60;
% options.RequestMethod = 'get';
% options.ContentType = 'text';
% data = webread(URL,options);


% URL = 'https://search1.odesi.ca/search?requestURL=((smoking))%26options%3Dodesi-opts2%26format%3Djson';
URL_json = 'http://search1.odesi.ca/search?requestURL=((*))%26options%3Dodesi-opts2%26format%3Djson%26pageLength%3D250';
URL_xml = 'http://search1.odesi.ca/search?requestURL=((*))%26options%3Dodesi-opts2%26format%3Dxml%26pageLength%3D250';

% data = webread(URL2);

outfilename = websave('scrape-test1.json',URL_json);
outfilename2 = websave('scrape-test1.xml',URL_xml);