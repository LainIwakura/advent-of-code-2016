#include <vector>
#include <iostream>
#include <regex>
#include <string>

#define ROWS 6
#define COLS 50

using namespace std;

// This isn't erlang but we can pretend if that's what you're into.
// But really, erlang was horrible for this problem.
vector<vector<bool>> init_grid()
{
    vector<vector<bool>> grid;
    for (int i = 0; i < ROWS; i++) {
        vector<bool> row;
        for (int j = 0; j < COLS; j++) {
            row.push_back(false);
        }
        grid.push_back(row);
    }

    return grid;
}

void print_grid(vector<vector<bool>>& grid)
{
    for (auto i = grid.begin(); i != grid.end(); i++) {
        for (auto j = (*i).begin(); j != (*i).end(); j++)
            cout << ((*j == false) ? "." : "#");
        cout << endl;
    }
}

void draw_rect(vector<vector<bool>>& grid, int x, int y)
{
    for (int i = 0; i < x; i++)
        for (int j = 0; j < y; j++)
            grid[j][i] = grid[j][i] | true;
}

void rotate_column(vector<vector<bool>>& grid, int rownum, int amt)
{
    vector<bool> p1;
    vector<bool> p2;
    amt = amt % ROWS; // normalize the rotation amount
    if (amt == 0) return;


    for (int i = 0; i < ROWS - amt; i++) 
        p1.push_back(grid[i][rownum]);
    for (int i = ROWS - amt; i < ROWS; i++)
        p2.push_back(grid[i][rownum]);

    p2.insert(end(p2), begin(p1), end(p1));

    for (int i = 0; i < ROWS; i++)
        grid[i][rownum] = p2[i];
}

// Much easier thanks to the rotate function found in <algorithm>
void rotate_row(vector<vector<bool>>& grid, int rownum, int amt)
{
    amt = amt % COLS;
    if (amt == 0) return;
    rotate(grid[rownum].rbegin(), grid[rownum].rbegin()+amt, grid[rownum].rend());
}

int count_lights(vector<vector<bool>>& grid)
{
    int cnt = 0;
    for (auto i = grid.begin(); i != grid.end(); i++)
        for (auto j = (*i).begin(); j != (*i).end(); j++)
            if (*j)
                ++cnt;
    return cnt;
}

int main()
{
    vector<vector<bool>> grid = init_grid();
    string line;
    while (getline(cin, line)) {
        smatch sm;
        if (regex_match(line, sm, regex("rect\\x20(\\d+)x(\\d+)"), regex_constants::match_default)) {
            int xdim = stoi(sm[1]);
            int ydim = stoi(sm[2]);
            draw_rect(grid, xdim, ydim);
            print_grid(grid);
            cout << "\n";
        } else if (regex_match(line, sm, regex("rotate\\x20(column|row)\\x20(x|y)=(\\d+)\\x20by\\x20(\\d+)"), regex_constants::match_default)) {
            int rownum = stoi(sm[3]);
            int amt = stoi(sm[4]);
            
            if (sm[1] == "column") {
                rotate_column(grid, rownum, amt);
                print_grid(grid);
                cout << "\n";
            } else if (sm[1] == "row") {
                rotate_row(grid, rownum, amt);
                print_grid(grid);
                cout << "\n";
            }
        } 
    }

    print_grid(grid);
    cout << "\nLit: " << count_lights(grid) << endl;

    return 0;
}
