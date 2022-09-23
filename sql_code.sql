DROP TABLE gitdata;
DROP TABLE gitissues;
-- commit_info--------------------------------------------------------------
SELECT author_timezone, COUNT(*) AS count_aut_timezone FROM commit_info
GROUP BY author_timezone ORDER BY count_aut_timezone DESC;

SELECT committer_timezone, COUNT(*) AS count_com_timezone FROM commit_info
GROUP BY committer_timezone ORDER BY count_com_timezone DESC;

SELECT distinct author_name, committer_name FROM commit_info;

SELECT distinct committer_name FROM commit_info ORDER BY committer_name DESC;

SELECT * FROM commit_info WHERE committer_name = '=';



SELECT author_date, committer_date, AGE(committer_date, author_date) FROM commit_info where committer_date != author_date;

SELECT *, AGE(committer_date, author_date) FROM commit_info where committer_name = author_name ORDER BY age DESC;

SELECT msg FROM commit_info where project_name = 'serve' AND CONTAINS (msg , 'A');

SELECT DISTINCT in_main_branch FROM commit_info; /* only "true" so delete this column */
ALTER TABLE commit_info
DROP COLUMN in_main_branch;

SELECT DISTINCT merge FROM commit_info; /* only "false" so delete this column */
ALTER TABLE commit_info
DROP COLUMN merge;

SELECT DISTINCT REPLACE(parents[1],'''','') FROM commit_info;





SELECT deletions, COUNT(*) AS count_deletion FROM commit_info
GROUP BY deletions ORDER BY count_deletion DESC;

SELECT insertions, COUNT(*) AS count_insert FROM commit_info
GROUP BY insertions ORDER BY count_insert DESC;

SELECT lines, COUNT(*) AS count_line FROM commit_info
GROUP BY lines ORDER BY count_line DESC;

SELECT files, COUNT(*) AS count_file FROM commit_info
GROUP BY files ORDER BY files DESC;

SELECT *, AGE(committer_date, author_date) from commit_info WHERE files = 1011;

SELECT * from commit_info WHERE committer_name = 'Facebook GitHub Bot' and committer_date != author_date;

-- update_info-------------------------------------------------------------
SELECT DISTINCT old_path, new_path, filename FROM update_info where old_path=new_path;

SELECT change_type, COUNT(*) AS count_change_type FROM update_info
GROUP BY change_type ORDER BY count_change_type DESC;

select distinct added_lines from update_info; 
ALTER TABLE update_info
DROP COLUMN added_lines;

SELECT deleted_lines, COUNT(*) AS count_delete_line FROM update_info
GROUP BY deleted_lines ORDER BY count_delete_line DESC;

SELECT nloc, COUNT(*) AS count_nloc FROM update_info
GROUP BY nloc ORDER BY count_nloc DESC;

SELECT complexity, COUNT(*) AS count_complexity FROM update_info
GROUP BY complexity ORDER BY count_complexity DESC;

SELECT token_count, COUNT(*) AS count_token FROM update_info
GROUP BY token_count ORDER BY count_token DESC;

SELECT * from commit_info LIMIT 50;

SELECT hash, parents, project_name from commit_info;

SELECT DISTINCT parents from commit_info;

SELECT hash from commit_info WHERE hash = 'a7edfe510582a664ff065f7277ca1401e2b07403'

select  diff distinct from update_info limit 20;

SELECT author_name, committer_name, author_date, committer_date, project_name FROM commit_info where project_name = 'pytorch' OR project_name = 'tensorflow' ;


SELECT DISTINCT user_name from gitIssues;

SELECT author_name, COUNT (*) AS counter FROM commit_info GROUP BY author_name ORDER BY counter DESC;



SELECT committer_name, project_name, COUNT (*) AS counter FROM commit_info WHERE committer_name = 'Facebook GitHub Bot' GROUP BY committer_name, project_name ORDER BY counter DESC;


SELECT DISTINCT author_name from commit_info;

SELECT DISTINCT author_name, committer_name from commit_info;

SELECT author_name, COUNT (DISTINCT committer_name) AS counter from commit_info GROUP BY author_name ORDER BY counter DESC;

SELECT committer_date from commit_info ORDER BY committer_date;



SELECT (closed_at - created_at), COUNT(issue_id) FROM issue GROUP BY (closed_at - created_at) ORDER BY (closed_at - created_at) DESC
SELECT created_at, closed_at, updated_at FROM issue ORDER BY created_at
SELECT count(issue_id) FROM issue WHERE  closed_at is NULL
SELECT created_at, closed_at, updated_at FROM issue WHERE updated_at > closed_at ORDER BY created_at 

SELECT n_comments, COUNT(issue_id) FROM issue GROUP BY n_comments ORDER BY n_comments 

SELECT COUNT(issue_id), user_name FROM issue GROUP BY user_name ORDER BY count(issue_id) DESC

SELECT body FROM issue
SELECT assignees from issue

DROP TABLE IF EXISTS issue_assignee;
CREATE TABLE issue_assignee AS
SELECT issue_id, REPLACE(assignee, '''', '') as assignee
FROM (SELECT issue_id, unnest(assignees) AS assignee FROM issue) as t;

DROP TABLE IF EXISTS issue_reaction;
CREATE TABLE issue_reaction AS
SELECT issue_id, REPLACE(reaction, '''', '') as reaction, COUNT(*) as n_reactions
FROM (SELECT issue_id, unnest(reactions) AS reaction FROM issue) as t
GROUP BY issue_id, reaction ORDER BY n_reactions DESC;

SELECT * from issue WHERE issue_id = '4603';

-- FROM
DROP TABLE IF EXISTS tags;
CREATE TABLE tags AS
SELECT issue_id, REPLACE(tag, '''', '') as tag
FROM (SELECT issue_id, unnest(labels) AS tag FROM issue) as t;

SELECT issue_id, tag from tags;
SELECT COUNT(*) as counter, tag FROM tags GROUP BY tag ORDER BY counter DESC;

DROP TABLE IF EXISTS issue_tag;
CREATE TABLE issue_tag AS
SELECT issue_id, tag, tag_type FROM(
SELECT issue_id,  (string_to_array(tag, ':'))[2] as tag, (string_to_array(tag, ':'))[1] as tag_type FROM tags WHERE cardinality((string_to_array(tag, ':'))) >1
UNION ALL
SELECT issue_id,  (string_to_array(tag, ':'))[1] as tag, NULL as tag_type FROM tags WHERE cardinality((string_to_array(tag, ':'))) =1
) as t
ORDER BY issue_id;
DROP TABLE IF EXISTS tags;

--To count how many issues contain a specific label
SELECT * FROM issue_tag;
SELECT count(*), tag_type FROM issue_tag GROUP BY tag_type ORDER BY count DESC;
-- END

SELECT COUNT(issue_id) as counter, tag FROM issue_tag WHERE tag_type = 'type' GROUP BY tag ORDER BY counter DESC
SELECT COUNT(issue_id) as counter, tag FROM issue_tag WHERE tag_type = 'size' GROUP BY tag ORDER BY counter DESC
SELECT COUNT(issue_id) as counter, tag FROM issue_tag WHERE tag_type = 'stat' GROUP BY tag ORDER BY counter DESC


-- [1] To calculate unique values 
SELECT COUNT(DISTINCT hash) as count_hash, COUNT(DISTINCT msg) as count_msg,
COUNT(DISTINCT author_name) as count_author_name, COUNT(DISTINCT committer_name) as count_committer_name,
COUNT(DISTINCT author_timezone) as count_author_timezone, COUNT(DISTINCT committer_timezone) as count_commiter_timezone,
COUNT(DISTINCT branches) as count_branches, COUNT(DISTINCT parents) as count_parents,
COUNT(DISTINCT project_name) as count_project_name, COUNT(DISTINCT files) as count_files
FROM commit_info;

SELECT msg, count(*) as count_msg from commit_info group by msg order by count_msg desc limit 15;

--Count parents where many commits
SELECT parents, count(*) as count_parents from commit_info group by parents order by count_parents desc limit 15; 

-- Commits distribution with respect to project
SELECT project_name, COUNT(*) AS count_proj FROM commit_info 
GROUP BY project_name ORDER BY count_proj DESC; 


--To count most popular types of issues that contain 'type' information
SELECT tag, COUNT(*) AS count_tag FROM issue_tag WHERE tag_type='type' GROUP BY tag ORDER BY count_tag DESC;



SELECT * from commit_info WHERE parents = '{''71e3a6d3a7cd6a0bfd924dad53a6bf24e17c884b''}' AND  msg iLIKE '%Add%';

-- To find out what projects have non-direct relation between commits and parents 
SELECT project_name, COUNT(*) AS count_project_name FROM commit_info WHERE parents IN
  (SELECT parents FROM commit_info GROUP BY parents HAVING COUNT(*) > 1) GROUP BY project_name;

-- Distinct projects
SELECT  COUNT(*), project_name from commit_info GROUP BY project_name ORDER BY count DESC;

--distribution for number of commits for dare_diff and average values per commit for deleted/added lines and changed files 
SELECT (committer_date - author_date) as date_diff, count (hash) as counter, 
ROUND(AVG(deletions),1) as deletions, 
ROUND(AVG(insertions),1) as insertions, 
ROUND(AVG(lines),1) as lines, 
ROUND(AVG(files),1) as files,
AVG(added_lines) as added_lines,
AVG(deleted_lines) as deleted_lines
-- add added_lines and deleted_lines
FROM commit_info LEFT JOIN (SELECT fk_hash, ROUND(SUM(added_lines),1) as added_lines, 
ROUND(SUM(deleted_lines),1) as deleted_lines 
 FROM update_info GROUP BY fk_hash) as ui
ON commit_info.hash = ui.fk_hash
GROUP BY (committer_date - author_date) 
ORDER BY (committer_date - author_date)

-- Distribution of committers with respect to the projects
SELECT committer_name, project_name, COUNT (*) AS counter FROM commit_info GROUP BY committer_name, project_name ORDER BY counter DESC;


-- Distribution of committers with respect to the projects + order by project name
SELECT committer_name, project_name, COUNT (*) AS counter FROM commit_info GROUP BY committer_name, project_name ORDER BY project_name, counter DESC;

-- Distribution of committers with respect to the projects + order by project name
SELECT committer_name, project_name, COUNT (*) AS counter FROM commit_info WHERE (project_name = 'tensorflow') AND (committer_name!='TensorFlower Gardener' AND committer_name!= 'GitHub') GROUP BY committer_name, project_name ORDER BY project_name, counter DESC;

--TO check most popular labels
DROP TABLE IF EXISTS tags;
CREATE TABLE tags AS
SELECT issue_id, REPLACE(tag, '''', '') as tag
FROM (SELECT issue_id, unnest(labels) AS tag FROM issue) as t;
SELECT issue_id, tag from tags;
SELECT COUNT(*) as counter, tag FROM tags GROUP BY tag ORDER BY counter DESC;

-- Count issues per project
SELECT  COUNT(*), project from issue GROUP BY project ORDER BY count DESC;


SELECT  created_at, count(created_at) from issue GROUP BY MONTH(created_at) ORDER BY created_at;

EXTRACT(MONTH FROM '2018-08-01')
 
SELECT   EXTRACT(YEAR FROM TIMESTAMP '2016-12-31 13:30:15'), EXTRACT (MONTH FROM TIMESTAMP '2016-12-31 13:30:15');

SELECT created_at from issue;

select to_char(created_at,'mm') as month_created,
       extract(year from created_at) as year_created,
       count("issue_id") as "Count_created"
from issue
where created_at > '2020-12-31'
group by 1,2
order by 2,1

select to_char(closed_at,'mm') as month_closed,
       extract(year from closed_at) as year_closed,
       count("issue_id") as "Count_closed"
from issue
where closed_at > '2020-12-31'
group by 1,2
order by 2,1

select to_char(updated_at,'mm') as month_updated,
       extract(year from updated_at) as year_updated,
       count("issue_id") as "Count_updated"
from issue
where updated_at > '2020-12-31'
group by 1,2
order by 2,1

--To count most popular types of issues that contain 'type' information
SELECT tag, COUNT(*) AS count_tag FROM issue_tag WHERE tag_type='type' GROUP BY tag ORDER BY count_tag DESC;


SELECT created_at, closed_at, closed_at-created_at AS difference from issue where project = 'tensorflow' order by difference DESC;

SELECT created_at, closed_at, closed_at-created_at AS difference from issue where project != 'tensorflow' order by difference DESC;

--create distributions for tensorflow
select width_bucket(closed_at-created_at, 0, 600, 6) as bucket, 
       count(*) as cnt from issue where project = 'tensorflow'
group by bucket 
order by bucket;

--create distributions for pytorch
select width_bucket(closed_at-created_at, 0, 1700, 10) as bucket, 
       count(*) as cnt from issue where project != 'tensorflow'
group by bucket 
order by bucket;

--To count most popular types of issues that contain 'type' information
SELECT tag, COUNT(*) AS count_tag FROM issue_tag WHERE tag_type='type' GROUP BY tag ORDER BY count_tag DESC;


SELECT closed_by, count(closed_by) as count_closed_by from issue where project = 'pytorch' group by closed_by order by count_closed_by DESC;


SELECT assignees, count(assignees) as count_assignees from issue where project != 'pytorch' group by assignees order by count_assignees DESC;



