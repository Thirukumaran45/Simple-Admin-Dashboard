import 'package:admin_pannel/controller/dashboardController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Statisticsection extends StatefulWidget {
  const Statisticsection({super.key});

  @override
  State<Statisticsection> createState() => _StatisticsectionState();
}

class _StatisticsectionState extends State<Statisticsection> {
  final DashboardController controller = Get.put(DashboardController());
  bool ascending = true;
  String sortColumn = 'sales';
  String filterCatagory = 'All';
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Data Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildDashboardcards(),
            SizedBox(height: 30),
            _buildchartRowS(),
            SizedBox(height: 30),
            _buildFilters(),
            SizedBox(height: 30),
            _buildDataTable(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3))
          ]),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Something is Wrong"),
            );
          }
          final data = _appluFilter(snapshot.data!);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                _buildDataColumn('product Name', 'Product Name'),
                _buildDataColumn('Catagory', 'Catagory'),
                _buildDataColumn('Sales', 'Sales', numeric: true),
                _buildDataColumn('Stocks', 'Stocks', numeric: true),
                _buildDataColumn('Total Revenue', 'Total Revenue'),
                _buildDataColumn('Average Order Value', 'Average Order Value'),
                _buildDataColumn('Date Added', 'Date Added'),
              ],
              rows: data
                  .map(
                    (e) => _buildDataRow(e),
                  )
                  .toList(),
              // sortColumnIndex: [
              //   'productName',
              //   'Catagory',
              //   'Sales',
              //   'Stocks',
              //   'Total Revenue',
              //   'Average Order Value',
              //   'Date Added'
              // ].indexOf(sortColumn),
              sortAscending: ascending,
            ),
          );
        },
      ),
    );
  }

  DataColumn _buildDataColumn(String lable, String key,
      {bool numeric = false}) {
    return DataColumn(
      label: Text(
        lable,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      numeric: numeric,
      onSort: (columnIndex, ascending) {
        setState(() {
          sortColumn = key;
          ascending = ascending;
        });
      },
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> item) {
    String formatNumber(dynamic value) {
      if (value == null) return 'N/A';
      // if (value is num) {
      //   return NumberFormat('#,###').formate(value);
      // }
      return value.toString();
    }

    String formateCurrency(dynamic value) {
      if (value == null) return 'N/A';
      // if (value is num) {
      //   return NumberFormat('#,###.00').formate(value);
      // }
      return value.toString();
    }

    String formateDate(dynamic value) {
      if (value == null) return 'N/A';
      // if (value is num) {
      //   return DateFormat('MM d yyyy').formate(DateTime.parse(value.toString()));
      // }
      return value.toString();
    }

    return DataRow(
      cells: [
        DataCell(Text(item['Product Name']?.toString() ?? "N/A")),
        DataCell(Text(item['Catagory']?.toString() ?? "N/A")),
        DataCell(Text(formatNumber(item['Sales']))),
        DataCell(Text(formatNumber(item['Stocks']))),
        DataCell(Text(formateCurrency(item['Total Revenue']))),
        DataCell(Text(formateCurrency(item['Average Order Value']))),
        DataCell(Text(formateDate(item['Date Added'])))
      ],
    );
  }

  List<Map<String, dynamic>> _appluFilter(List<Map<String, dynamic>> data) {
    String searchText = searchController.text.toLowerCase();
    var filterData = data.where(
      (element) {
        if (filterCatagory != "All" && element['Catagory'] != filterCatagory) {
          return false;
        }
        if (searchText.isNotEmpty &&
            !element['productName'].toLowerCase().contains(searchText)) {
          return false;
        }
        return true;
      },
    ).toList();
    filterData.sort(
      (a, b) {
        var aValue = a[sortColumn];
        var bValue = b[sortColumn];
        if (aValue is String && bValue is String) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else if (aValue is num && bValue is num) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }
        return 0;
      },
    );
    return filterData;
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3))
          ]),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: searchController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
                hintText: "Search Products",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[100],
                filled: true),
          )),
          SizedBox(
            width: 16,
          ),
          DropdownButton<String>(
            value: filterCatagory,
            icon: Icon(Icons.filter_list),
            style: TextStyle(fontSize: 16, color: Colors.black87),
            items: [
              "All",
              "Catagory 1",
              "Catagory 2",
              "Catagory 3",
              "Catagory 4",
            ]
                .map((cataroy) => DropdownMenuItem(
                      value: cataroy,
                      child: Text(cataroy),
                    ))
                .toList(),
            onChanged: (value) => setState(() {}),
          )
        ],
      ),
    );
  }

  Widget _buildDashboardcards() {
    return Row(
      children: [
        _buildCard("Total Revenue", "\$25,000", Icons.attach_money,
            Colors.greenAccent),
        _buildCard(
            "Avg order Value", "\$2000", Icons.bar_chart, Colors.blueAccent),
        _buildCard(
            "Total Customers", "\$240", Icons.people, Colors.purpleAccent),
        _buildCard(
            "Total Product", "\$2500", Icons.inventory, Colors.orangeAccent),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.9)),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildchartRowS() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 350,
          child: _buildLinchart(),
        ),
        SizedBox(
          width: 350,
          child: _buildBarchart(),
        ),
        SizedBox(
          width: 350,
          child: _buildPieChart(),
        )
      ],
    );
  }

  Widget _buildLinchart() {
    return _buildChartContainer(
        title: "Sales Trend",
        chart: LineChart(LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  ['jan', 'feb', 'mar', 'apr', 'may'][value.toInt()],
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}k',
                          style: TextStyle(fontSize: 12, color: Colors.grey)))),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                  spots: [
                    FlSpot(0, 1),
                    FlSpot(1, 1.5),
                    FlSpot(2, 2),
                    FlSpot(3, 2.5),
                    FlSpot(4, 3),
                  ],
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                      show: true, color: Colors.blue.withOpacity(0.1)))
            ],
            lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchbarSpots) {
                  return touchbarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    return LineTooltipItem(
                        '${flSpot.y}', TextStyle(color: Colors.white));
                  }).toList();
                })))));
  }

  Widget _buildChartContainer({required String title, required Widget chart}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 200,
            child: chart,
          )
        ],
      ),
    );
  }

  Widget _buildBarchart() {
    return _buildChartContainer(
        title: 'Catogory ',
        chart: BarChart(BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barTouchData: BarTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(rod.toY.round().toString(),
                      TextStyle(color: Colors.white));
                })),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = ["A", "B", "C", "D"];
                  return Text(
                    titles[value.toInt()],
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  );
                },
              )),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}k',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  );
                },
              )),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [
                BarChartRodData(toY: 10, color: Colors.blueAccent)
              ]),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(toY: 12, color: Colors.blueAccent)
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(toY: 14, color: Colors.blueAccent)
              ]),
              BarChartGroupData(
                  x: 3,
                  barRods: [BarChartRodData(toY: 9, color: Colors.blueAccent)])
            ])));
  }

  Widget _buildPieChart() {
    return _buildChartContainer(
        title: "Revenue Distribution",
        chart: PieChart(
            PieChartData(sectionsSpace: 0, centerSpaceRadius: 50, sections: [
          PieChartSectionData(
              value: 40,
              color: Colors.blueAccent,
              title: "40%",
              titleStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          PieChartSectionData(
              value: 40,
              color: Colors.green,
              title: "30%",
              titleStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          PieChartSectionData(
              value: 40,
              color: Colors.orangeAccent,
              title: "30%",
              titleStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold))
        ])));
  }
}
