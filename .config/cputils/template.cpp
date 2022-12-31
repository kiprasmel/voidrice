#pragma  GCC optimize     ("O3")

#if (0 || defined(DEBUG)) && !defined(EVAL)
	#include "debug.h" // https://github.com/kiprasmel/debug.h
#else
	struct debug {
		template <class c> debug& operator <<(const c&) { return * this; } };
	#define imie(...) ""
#endif

#include         <bits/stdc++.h>
using             namespace std;

typedef           long long  ll;
typedef  unsigned long long ull;

constexpr ll  INFLL =  1e18 + 8;
constexpr int INF   =  1e9  + 8;
constexpr int MOD   =  1e9  + 7;



int main() {
	ios::sync_with_stdio(0);
	cin.tie(0);

	<++>

	return 0;
}

