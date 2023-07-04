function mutpopright(entity, eleID, myData, max) {
	var dom = document.getElementById(eleID);
	var myChart = echarts.init(dom, null, {
		renderer: 'svg',
		useDirtyRect: false
	});
	var app = {};

	var option;

	var data = myData;
	console.log(max);
	const schema = [
		{
			name: 'Mut',
			index: 0,
			text: 'Mut'
		},
		{
			name: 'RMSD',
			index: 1,
			text: 'RMSD'
		},
	];
	const itemStyle = {
		opacity: 0.8,
		shadowBlur: 10,
		shadowOffsetX: 0,
		shadowOffsetY: 0,
		shadowColor: 'rgba(0,0,0,0.3)',

	};
	option = {
		color: ['#dd4444'],
		// color: new echarts.graphic.RadialGradient(0.4, 0.3, 1, [
		//           {
		//             offset: 0,
		//             color: 'rgb(129, 227, 238)'
		//           },
		//           {
		//             offset: 1,
		//             color: 'rgb(25, 183, 207)'
		//           }
		//         ],
		legend: {
			top: 10,
			textStyle: {
				fontSize: 16
			}
		},
		grid: {
			left: '10%',
			right: 150,
			top: '18%',
			bottom: '10%'
		},
		tooltip: {
			backgroundColor: 'rgba(255,255,255,0.7)',
			formatter: function(param) {
				var value = param.value;
				// prettier-ignore
				return '<div style="border-bottom: 1px solid rgba(255,255,255,.3); font-size: 18px;padding-bottom: 7px;margin-bottom: 7px">' +
					value[2] +
					'</div>' +
					value[3] + '<br>' +
					'RMSD: ' + value[1] + '<br>';
			}
		},
		xAxis: {
			type: 'category',
			name: 'Mut',
			// axisLabel:{interval:0},
			nameGap: 16,
			nameTextStyle: {
				fontSize: 16
			},
			// max: 31,
			splitLine: {
				show: false
			}
		},
		yAxis: {
			type: 'value',
			name: 'RMSD',
			nameLocation: 'end',
			nameGap: 20,
			nameTextStyle: {
				fontSize: 16
			},
			splitLine: {
				show: false
			}
		},
		visualMap: [{
			left: 'right',
			top: '10%',
			dimension: 1,
			min: 0,
			max: max,
			itemWidth: 20,
			itemHeight: 150,
			calculable: true,
			precision: 0.1,
			text: ['CircleSize: RMSD'],
			textGap: 30,
			inRange: {
				symbolSize: [10,60],
				colorLightness: [0.9, 0.5]
			},
			outOfRange: {
				symbolSize: [10,60],
				color: ['rgba(155, 255, 210, 0.4)']
			},
			controller: {
				inRange: {
					color: ['#c23531']
				},
				outOfRange: {
					color: ['#93dcdc']
				}
			}
		}, ],
		series: [{
			name: entity,
			type: 'scatter',
			itemStyle: itemStyle,
			data: data,
		}, ]
	};

	if (option && typeof option === 'object') {
		myChart.setOption(option);
	}

	window.addEventListener('resize', myChart.resize);
}