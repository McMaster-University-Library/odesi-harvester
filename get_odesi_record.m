% URL = 'https://search1.odesi.ca/#/details?uri=%2Fodesi%2Fcipo-598-E-1993-04.xml';
% str = urlread(URL);

% odesi API documentation - https://spotdocs.scholarsportal.info/display/api/ODESI+API+and+Feeds
% Nesstar doc http://www.nesstar.com/software/public_api.html

options = weboptions;
options.Timeout = 60;
% options.RequestMethod = 'get';
% options.ContentType = 'text';
% data = webread(URL,options);


% URL = 'https://search1.odesi.ca/search?requestURL=((smoking))%26options%3Dodesi-opts2%26format%3Djson';
URL_json = 'http://search1.odesi.ca/search?requestURL=((*))%26options%3Dodesi-opts2%26format%3Djson%26pageLength%3D100';
% URL_xml = 'http://search1.odesi.ca/search?requestURL=((*))%26options%3Dodesi-opts2%26format%3Dxml%26pageLength%3D750';

% data = webread(URL2);

outfilename = websave('scrape-test1.json',URL_json,options);
% outfilename2 = websave('scrape-test1.xml',URL_xml);

%% Read JSON

file_in = fileread('scrape-test1.json');
tmp = jsondecode(file_in);

% title: tmp.results(1).metadata{end,1}.TI_facet % i.e. the last element
% date: tmp.results(1).metadata{end-1,1}.date % i.e. the next to last element
% abstract: tmp.results(1).metadata{1,1}.date % i.e. the next to last element

%% Iterate through the JSON, put into a table (cell array)
for i = 1:1:length(tmp.results)
% url = https://odesi.ca/#/details?uri=/icpsr/03116.xml    
%     url = ['https://odesi.ca/#/details?uri=' tmp.results(i).uri];
%     out{i,1} = tmp.results(i).metadata{end,1};   % title
%     out{i,2} = tmp.results(i).metadata{end-1,1}; % date
%     out{i,3} = tmp.results(i).metadata{4,1};     % producer
%     out{i,4} = tmp.results(i).metadata{1,1};     % abstract
%     out{i,5} = tmp.results(i).metadata{2,1};     % citation
    % find keywords
    out{i,6} = '';
    for j = 1:1:length(tmp.results(i).metadata)
        fnames = fieldnames(tmp.results(i).metadata{j,1});
        element_name = fnames{1,1};
        element_value = tmp.results(i).metadata{j,1}.(fnames{1,1});
        % replace newline characters  
        element_value = regexprep(element_value,'[\n\r]+','');
        switch element_name
            case 'TI_facet'
                out{i,1} = element_value;
            case 'SE_facet'
                out{i,7} = element_value;
            case 'abstract'
                out{i,4} = element_value;
            case 'biblCit'
                out{i,5} = element_value;
            case 'AuthEnty'
                out{i,3} = element_value;
            case 'keyword' 
                out{i,6} = [out{i,6} element_value '; '];
            case 'date'
                out{i,2} = element_value; 
        end
    end
    out{i,7} = ['https://odesi.ca/#/details?uri=' tmp.results(i).uri];
    out{i,6} = out{i,6}(1:end-2);
end


%% Export to a csv file
varnames = {'Dataset Title' 'Date' 'Producer' 'Abstract' 'How to Cite This' 'Keywords' 'Access URL'};
% Convert cell to a table
T = cell2table(out,'VariableNames',varnames);
% Write the table to a CSV file
writetable(T,'odesi-out.csv')

