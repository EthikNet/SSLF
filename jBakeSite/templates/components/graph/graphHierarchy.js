
$(document).ready(function(){
	$(".hierarchyGraph").each(function () {
		var divGraphContainer = $(this);
		buildGraph(divGraphContainer.attr('id'), divGraphContainer.data('graphData'), divGraphContainer.data('graphParam'));
	})
});

function buildGraph(graphId, graphData, orgGraphOptions){
	console.log("buildGraph : Building Hierachical Graph : id : " + graphId + " with data source size : " + graphData.length + " characters");

	cleanGraphData = JSON.parse(graphData.replace(/(\r\n|\n|\r|\t)/gm, "").replace(/'/gm, '"'));
	
	
	var oc = new OrgChart({
		chartContainer: '#'+graphId,
		'data' : cleanGraphData,
		'nodeContent': 'title',
		'createNode': function(node, data) {
				if ("photo" in data) {
		        	node.insertAdjacentHTML("afterbegin", "<img class=\"avatar\" src=\"" + data.photo + "\"/>");
				}
		      }
	});
	
	cleanGraphParams = JSON.parse(orgGraphOptions.replace(/(\r\n|\n|\r|\t)/gm, "").replace(/'/gm, '"'));
	
	for(var i=0 ; i < cleanGraphParams.length ; i++){
		console.log("buildGraph : setting option : " + cleanGraphParams[i].param + ", with value : " + cleanGraphParams[i].value);
		oc.setOptions(cleanGraphParams[i].param, cleanGraphParams[i].value);
	};

};
