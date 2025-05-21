<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    public function run()
    {
        User::create([
            'name' => 'Admin Ayam Geprek AA',
            'email' => 'admin@ayamgeprek.com',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);
    }
}
