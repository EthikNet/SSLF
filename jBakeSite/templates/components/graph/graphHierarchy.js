
$(document).ready(function(){
	$(".hierarchyGraph").each(function () {
		var divGraphContainer = $(this);
		buildGraph(divGraphContainer.attr('id'), divGraphContainer.data('graphData'));
	})
});

function buildGraph(graphId, graphData){
	console.log("Building Hierachical Graph : id : " + graphId + " with data source size : " + graphData.length + " characters");

	cleanGraphData = JSON.parse(graphData.replace(/(\r\n|\n|\r|\t)/gm, "").replace(/'/gm, '"'));
	var oc = new OrgChart({
		chartContainer: '#'+graphId,
		'data' : cleanGraphData,
		'nodeContent': 'title'
	});

};
