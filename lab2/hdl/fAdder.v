module halfAdd (
	output sum, cout;
	input a, b, cin;
);

assign {cout, sum} = a + b + cin;
