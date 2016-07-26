function clustered_data=EM_clustering_ver2p1(data,no_of_clusters)

no_of_data_pts=size(data,1);
% Initialize clusters by using the kmeans function in matlab

[Index,cluster_centers]=kmeans(data,no_of_clusters);

%estimate class priors using results from kmeans

for cluster=1:no_of_clusters
    cluster_points=find(Index==cluster);
    priors(cluster)=length(cluster_points)/no_of_data_pts;
    covariance_matrix(:,:,cluster)=cov(data(cluster_points,1:2));
end

converged=0;

% Expectation step

for data_pt=1:no_of_data_pts
    data_pt_probability=0;
    for cluster=1:no_of_clusters
        data_pt_probability=data_pt_probability+mvnpdf(data(data_pt,1:no_of_clusters),cluster_centers(cluster,:),covariance_matrix(:,:,cluster))*priors(cluster);
    end
    
    for cluster=1:no_of_clusters
        P(data_pt,cluster)=mvnpdf(data(data_pt,1:no_of_clusters),cluster_centers(cluster,:),covariance_matrix(:,:,cluster))*priors(cluster)/data_pt_probability;
    end
end


% Maximization step
% Update priors based on the new clustering probabilities we calculated
priors=sum(P)/no_of_data_pts;

for cluster=1:no_of_clusters
    cluster_centers(cluster,:)=(1/sum(P(:,cluster)))*sum(P(:,cluster).*data);
    covariance_matrix(;,:,cluster)=0;
    for data_pt=1:no_of_data_pts
        covariance_matrix(:,:,cluster)=covariance_matrix(:,:,cluster)+P(data_pt,cluster)*((data(data_pt,:)-cluster_centers(cluster,:))*(data(data_pt,:)-cluster_centers(cluster,:))');
    end
    
    covariance_matrix(:,:,cluster)=covariance_matrix(:,:,cluster)/sum(P(;,cluster);