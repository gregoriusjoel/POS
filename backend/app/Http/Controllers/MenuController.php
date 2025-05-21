<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Menu;

class MenuController extends Controller
{
    public function index()
    {
        $menus = Menu::all();
        return response()->json([
            'status' => 'success',
            'data' => $menus
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric',
            'description' => 'nullable|string',
            'category' => 'required|string|max:100',
        ]);

        $menu = Menu::create($request->only(['name', 'price', 'description', 'category']));

        return response()->json([
            'status' => 'success',
            'data' => $menu
        ], 201);
    }

    public function show($id)
    {
        $menu = Menu::findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $menu
        ]);
    }

    public function update(Request $request, $id)
    {
        $menu = Menu::findOrFail($id);

        $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'price' => 'sometimes|required|numeric',
            'description' => 'nullable|string',
            'category' => 'sometimes|required|string|max:100',
        ]);

        $menu->update($request->only(['name', 'price', 'description', 'category']));

        return response()->json([
            'status' => 'success',
            'data' => $menu
        ]);
    }

    public function getByCategory($category)
    {
        $menus = Menu::where('category', $category)->get();
        return response($menus);
    }

    public function destroy($id)
    {
        $menu = Menu::findOrFail($id);
        $menu->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Menu deleted successfully'
        ]);
    }
}
